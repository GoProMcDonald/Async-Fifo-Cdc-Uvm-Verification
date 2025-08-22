import uvm_pkg::*; `include "uvm_macros.svh"
import txn_wr_pkg::*;
class wr_sequencer extends uvm_sequencer#(wr_txn);
  `uvm_component_utils(wr_sequencer)
  function new(string name, uvm_component parent); super.new(name,parent); endfunction
endclass
