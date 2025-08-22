import uvm_pkg::*; `include "uvm_macros.svh"
import txn_wr_pkg::*;

class wr_driver extends uvm_driver #(wr_txn);
  `uvm_component_utils(wr_driver)
  virtual fifo_if.WR vif;
  function new(string name, uvm_component parent); super.new(name,parent); endfunction

  task run_phase(uvm_phase phase);
    vif.wr_en <= 0; vif.wr_data <= '0; @(posedge vif.wr_clk);
    forever begin
      wr_txn tr; seq_item_port.get_next_item(tr);
      for (int i=0;i<tr.burst_len;i++) begin
        @(posedge vif.wr_clk);
        if (!vif.rst_n_wr) begin i--; continue; end
        if (!vif.wr_full) begin
          vif.wr_data <= $urandom();
          vif.wr_en   <= 1'b1;
        end else begin
          vif.wr_en <= 1'b0; i--; // back-pressure
        end
      end
      @(posedge vif.wr_clk); vif.wr_en <= 0;
      seq_item_port.item_done();
    end
  endtask
endclass
