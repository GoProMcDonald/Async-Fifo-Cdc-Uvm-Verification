import uvm_pkg::*; `include "uvm_macros.svh"
class wr_monitor extends uvm_component;
  `uvm_component_utils(wr_monitor)
  virtual fifo_if.MON_WR vif;
  uvm_analysis_port#(bit [31:0]) ap_data;
  function new(string name, uvm_component parent); super.new(name,parent); ap_data=new("ap_data",this); endfunction
  task run_phase(uvm_phase phase);
    forever begin @(posedge vif.wr_clk); if (vif.wr_en && !vif.wr_full) ap_data.write(vif.wr_data); end
  endtask
endclass
