import uvm_pkg::*; `include "uvm_macros.svh"
package txn_rd_pkg;
  class rd_txn extends uvm_sequence_item;
    `uvm_object_utils(rd_txn)
    rand int unsigned burst_len;
    constraint c_len { burst_len inside {[1:32]}; }
    function new(string name="rd_txn"); super.new(name); endfunction
  endclass
endpackage
