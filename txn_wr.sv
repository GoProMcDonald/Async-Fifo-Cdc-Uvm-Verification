import uvm_pkg::*; `include "uvm_macros.svh"
package txn_wr_pkg;
  class wr_txn extends uvm_sequence_item;
    `uvm_object_utils(wr_txn)
    rand bit [31:0] data;
    rand int unsigned burst_len;
    constraint c_len { burst_len inside {[1:32]}; }
    function new(string name="wr_txn"); super.new(name); endfunction
  endclass
endpackage
