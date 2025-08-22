import uvm_pkg::*; `include "uvm_macros.svh"
import txn_rd_pkg::*;
class rd_agent extends uvm_agent;
  `uvm_component_utils(rd_agent)
  virtual fifo_if.RD     vif_drv;
  virtual fifo_if.MON_RD vif_mon;
  rd_sequencer  seqr; rd_driver drv; rd_monitor mon;
  uvm_analysis_port#(bit [31:0]) ap_rd_drv; // data observed at driver after 1-cycle latency
  uvm_analysis_port#(bit [31:0]) ap_rd_mon; // data from monitor
  function new(string name, uvm_component parent); super.new(name,parent); ap_rd_drv=new("ap_rd_drv",this); ap_rd_mon=new("ap_rd_mon",this); endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr=rd_sequencer::type_id::create("seqr",this);
    drv=rd_driver   ::type_id::create("drv",this);
    mon=rd_monitor  ::type_id::create("mon",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    drv.vif = vif_drv; mon.vif=vif_mon; drv.ap_data.connect(ap_rd_drv); mon.ap_data.connect(ap_rd_mon);
  endfunction
endclass
