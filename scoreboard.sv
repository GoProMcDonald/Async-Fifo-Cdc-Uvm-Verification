import uvm_pkg::*; `include "uvm_macros.svh"
class scoreboard extends uvm_component;
  `uvm_component_utils(scoreboard)
  uvm_analysis_export#(bit [31:0]) exp_wr;
  uvm_analysis_export#(bit [31:0]) exp_rd_drv;
  uvm_analysis_export#(bit [31:0]) exp_rd_mon;
  bit [31:0] q[$]; // expected data queue

  event ev_wr, ev_rd; int depth_samples; int max_depth;

  function new(string name, uvm_component parent); super.new(name,parent);
    exp_wr=new("exp_wr",this); exp_rd_drv=new("exp_rd_drv",this); exp_rd_mon=new("exp_rd_mon",this);
  endfunction

  // dummy
  function void write(input bit [31:0] t); endfunction
  `uvm_analysis_imp_decl(_wr)
  `uvm_analysis_imp_decl(_rd_drv)
  `uvm_analysis_imp_decl(_rd_mon)
  uvm_analysis_imp_wr     #(bit[31:0],scoreboard) imp_wr;
  uvm_analysis_imp_rd_drv #(bit[31:0],scoreboard) imp_rd_drv;
  uvm_analysis_imp_rd_mon #(bit[31:0],scoreboard) imp_rd_mon;

  function void build_phase(uvm_phase phase);
    imp_wr     = new("imp_wr",this);
    imp_rd_drv = new("imp_rd_drv",this);
    imp_rd_mon = new("imp_rd_mon",this);
  endfunction

  // push expected (write path)
  function void write_wr(bit [31:0] d);
    q.push_back(d); depth_samples=q.size(); if (q.size()>max_depth) max_depth=q.size(); ->ev_wr;
  endfunction

  // pop & compare (read path via driver)
  function void write_rd_drv(bit [31:0] d);
    if (q.size()==0) `uvm_error("SCOREBOARD","Read with empty expected queue")
    else begin
      bit [31:0] exp=q.pop_front();
      if (d!==exp) `uvm_error("SCOREBOARD",$sformatf("Mismatch exp=%h got=%h",exp,d));
      ->ev_rd;
    end
  endfunction

  // monitor path：可用于可视化或扩展交叉校验
  function void write_rd_mon(bit [31:0] d);
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("SCOREBOARD", $sformatf("Max in-flight depth observed=%0d", max_depth), UVM_LOW)
  endfunction
endclass
