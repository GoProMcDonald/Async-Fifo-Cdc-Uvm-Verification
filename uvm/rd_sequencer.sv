import uvm_pkg::*; `include "uvm_macros.svh"
import txn_rd_pkg::*;
class rd_sequencer extends uvm_sequencer#(rd_txn);
  `uvm_component_utils(rd_sequencer)
  function new(string name, uvm_component parent); super.new(name,parent); endfunction
endclass
