import uvm_pkg::*; `include "uvm_macros.svh"
import txn_wr_pkg::*;
class wr_agent extends uvm_agent;
  `uvm_component_utils(wr_agent)
  virtual fifo_if.WR     vif_drv;
  virtual fifo_if.MON_WR vif_mon;
  wr_sequencer  seqr; wr_driver drv; wr_monitor mon;
  uvm_analysis_port#(bit [31:0]) ap_wr;
  function new(string name, uvm_component parent); super.new(name,parent); ap_wr=new("ap_wr",this); endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr=wr_sequencer::type_id::create("seqr",this);
    drv=wr_driver   ::type_id::create("drv",this);
    mon=wr_monitor  ::type_id::create("mon",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    drv.vif = vif_drv; mon.vif = vif_mon; mon.ap_data.connect(ap_wr);
  endfunction
endclass
