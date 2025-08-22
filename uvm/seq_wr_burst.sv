import uvm_pkg::*; `include "uvm_macros.svh"
import txn_wr_pkg::*;
class seq_wr_burst extends uvm_sequence#(wr_txn);
  `uvm_object_utils(seq_wr_burst)
  rand int unsigned num_txn; constraint c_n { num_txn inside {[50:200]}; }
  function new(string name="seq_wr_burst"); super.new(name); endfunction
  task body();
    repeat (num_txn) begin
      wr_txn t=wr_txn::type_id::create("t"); 
      assert(t.randomize() with { burst_len inside {[1:16]}; });
      start_item(t); finish_item(t);
    end
  endtask
endclass
