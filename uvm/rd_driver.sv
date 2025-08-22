import uvm_pkg::*; `include "uvm_macros.svh"
import txn_rd_pkg::*;

class rd_driver extends uvm_driver #(rd_txn);
  `uvm_component_utils(rd_driver)
  virtual fifo_if.RD vif;
  uvm_analysis_port#(bit [31:0]) ap_data; // forward read data to scoreboard
  function new(string name, uvm_component parent); super.new(name,parent); ap_data=new("ap_data",this); endfunction

  task run_phase(uvm_phase phase);
    vif.rd_en <= 0; @(posedge vif.rd_clk);
    forever begin
      rd_txn tr; seq_item_port.get_next_item(tr);
      for (int i=0;i<tr.burst_len;i++) begin
        @(posedge vif.rd_clk);
        if (!vif.rst_n_rd) begin i--; continue; end
        if (!vif.rd_empty) begin
          vif.rd_en <= 1'b1;
        end else begin
          vif.rd_en <= 1'b0; i--; // wait for data
        end
        @(posedge vif.rd_clk);
        if (vif.rd_valid) ap_data.write(vif.rd_data);
      end
      vif.rd_en <= 0; seq_item_port.item_done();
    end
  endtask
endclass
