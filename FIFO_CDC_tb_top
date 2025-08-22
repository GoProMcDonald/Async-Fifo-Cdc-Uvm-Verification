`timescale 1ns/1ps
import uvm_pkg::*; `include "uvm_macros.svh"
import clocks_pkg::*;

module tb_top;
  parameter int DATA_W=32;
  parameter int DEPTH =256;

  // Clocks and resets
  logic wr_clk=0, rd_clk=0;
  logic rst_n_wr=0, rst_n_rd=0;

  // User controls
  int WR_MHZ=400, RD_MHZ=100; // overridable via +WR_MHZ= +RD_MHZ=
  time SIM_TIME = 1ms;        // +SIM_TIME=

  initial begin
    void'($value$plusargs("WR_MHZ=%d", WR_MHZ));
    void'($value$plusargs("RD_MHZ=%d", RD_MHZ));
    string t; if ($value$plusargs("SIM_TIME=%s", t)) SIM_TIME = t.atoi();
    $display("[TB] WR_MHZ=%0d RD_MHZ=%0d SIM_TIME=%0t", WR_MHZ, RD_MHZ, SIM_TIME);

    // 将虚接口传入 UVM 配置数据库
    uvm_config_db#(virtual fifo_if.WR)::set(null, "*", "vif_wr", fifoi);
    uvm_config_db#(virtual fifo_if.RD)::set(null, "*", "vif_rd", fifoi);
    uvm_config_db#(int unsigned)::set(null, "tb_top", "WR_MHZ", WR_MHZ);
    uvm_config_db#(int unsigned)::set(null, "tb_top", "RD_MHZ", RD_MHZ);
  end

  // Clock gen (half-period in ns ~ 500/MHz)
  real wr_half_ns, rd_half_ns;
  initial begin
    wr_half_ns = 500.0/WR_MHZ; rd_half_ns = 500.0/RD_MHZ;
    forever #(wr_half_ns) wr_clk = ~wr_clk;
  end
  initial begin
    // skewed start for CDC stress
    #(rd_half_ns * ($urandom_range(1,5)));
    forever #(rd_half_ns) rd_clk = ~rd_clk;
  end

  // Reset sequence with optional mid-run blips
  initial begin
    rst_n_wr=0; rst_n_rd=0; repeat (5) @(posedge wr_clk); rst_n_wr=1; repeat (5) @(posedge rd_clk); rst_n_rd=1;
    if ($urandom_range(0,1)) begin // optional mid-run reset to stress CDC
      #(SIM_TIME/2);
      $display("[TB] Mid-run reset pulse");
      rst_n_wr=0; rst_n_rd=0; repeat (3) @(posedge wr_clk); rst_n_wr=1; repeat (3) @(posedge rd_clk); rst_n_rd=1;
    end
  end

  // Interface
  fifo_if #(.DATA_W(DATA_W)) fifoi (.wr_clk(wr_clk), .rd_clk(rd_clk), .rst_n_wr(rst_n_wr), .rst_n_rd(rst_n_rd));

  // DUT
  async_fifo #(.DATA_W(DATA_W), .DEPTH(DEPTH)) dut (
    .wr_clk(wr_clk), .rst_n_wr(rst_n_wr), .wr_en(fifoi.wr_en), .wr_data(fifoi.wr_data), .wr_full(fifoi.wr_full),
    .rd_clk(rd_clk), .rst_n_rd(rst_n_rd), .rd_en(fifoi.rd_en), .rd_data(fifoi.rd_data), .rd_valid(fifoi.rd_valid), .rd_empty(fifoi.rd_empty)
  );

  // UVM
  initial begin
    run_test();
  end
endmodule
