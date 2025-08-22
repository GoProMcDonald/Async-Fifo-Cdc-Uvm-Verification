import uvm_pkg::*; `include "uvm_macros.svh"
class rd_monitor extends uvm_component;
  `uvm_component_utils(rd_monitor)
  virtual fifo_if.MON_RD vif;
  uvm_analysis_port#(bit [31:0]) ap_data;
  function new(string name, uvm_component parent); super.new(name,parent); ap_data=new("ap_data",this); endfunction
  task run_phase(uvm_phase phase);
    forever begin @(posedge vif.rd_clk); if (vif.rd_valid) ap_data.write(vif.rd_data); end
  endtask
endclass
