import uvm_pkg::*; `include "uvm_macros.svh"
import txn_rd_pkg::*;
class seq_rd_burst extends uvm_sequence#(rd_txn);
  `uvm_object_utils(seq_rd_burst)
  rand int unsigned num_txn; constraint c_n { num_txn inside {[50:200]}; }
  function new(string name="seq_rd_burst"); super.new(name); endfunction
  task body();
    repeat (num_txn) begin
      rd_txn t=rd_txn::type_id::create("t"); 
      assert(t.randomize() with { burst_len inside {[1:16]}; });
      start_item(t); finish_item(t);
    end
  endtask
endclass
