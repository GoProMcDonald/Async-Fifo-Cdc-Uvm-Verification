import uvm_pkg::*; `include "uvm_macros.svh"
import txn_wr_pkg::*; import txn_rd_pkg::*;
class vseqr extends uvm_sequencer;
  `uvm_component_utils(vseqr)
  wr_sequencer wr_sqr; rd_sequencer rd_sqr;
  function new(string name, uvm_component parent); super.new(name,parent); endfunction
endclass
