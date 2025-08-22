`include "uvm_macros.svh"
import uvm_pkg::*;
import gray_code_pkg::*;

module async_fifo #(
  parameter int DATA_W = 32,
  parameter int DEPTH  = 256,
  localparam int AW    = $clog2(DEPTH)
)(
  // Write domain
  input  logic                 wr_clk,
  input  logic                 rst_n_wr,
  input  logic                 wr_en,
  input  logic [DATA_W-1:0]    wr_data,
  output logic                 wr_full,
  // Read domain
  input  logic                 rd_clk,
  input  logic                 rst_n_rd,
  input  logic                 rd_en,
  output logic [DATA_W-1:0]    rd_data,
  output logic                 rd_valid,
  output logic                 rd_empty
);
  // Pointers (binary + gray)
  logic [AW:0] wr_bin, wr_bin_n, wr_gray, wr_gray_n;
  logic [AW:0] rd_bin, rd_bin_n, rd_gray, rd_gray_n;

  // Cross-domain synchronized pointers
  logic [AW:0] rd_gray_wrclk, wr_gray_rdclk;

  // Memory
  logic ram_we, ram_re;
  fifo_ram #(.DATA_W(DATA_W), .DEPTH(DEPTH)) u_ram (
    .wr_clk(wr_clk), .rd_clk(rd_clk),
    .we(ram_we), .waddr(wr_bin[AW-1:0]), .wdata(wr_data),
    .re(ram_re), .raddr(rd_bin[AW-1:0]), .rdata(rd_data)
  );

  // Write domain logic
  assign ram_we   = wr_en & ~wr_full;
  assign wr_bin_n = wr_bin + (ram_we ? 1 : 0);
  assign wr_gray  = bin2gray#(AW+1)(wr_bin);
  assign wr_gray_n= bin2gray#(AW+1)(wr_bin_n);

  // Sync read gray into write clock domain
  sync2d #(.W(AW+1)) u_sync_rd2wr (.clk(wr_clk), .rst_n(rst_n_wr), .d(rd_gray), .q(rd_gray_wrclk));

  // Full: next write gray equals read gray with MSBs inverted
  wire [AW:0] rd_gray_wrclk_inv = {~rd_gray_wrclk[AW:AW-1], rd_gray_wrclk[AW-2:0]};
  always_ff @(posedge wr_clk or negedge rst_n_wr) begin
    if (!rst_n_wr) begin
      wr_bin <= '0;
      wr_full <= 1'b0;
    end else begin
      wr_bin <= wr_bin_n;
      wr_full <= (wr_gray_n == rd_gray_wrclk_inv);
    end
  end

  // Read domain logic
  assign ram_re    = rd_en & ~rd_empty;
  assign rd_bin_n  = rd_bin + (ram_re ? 1 : 0);
  assign rd_gray   = bin2gray#(AW+1)(rd_bin);
  assign rd_gray_n = bin2gray#(AW+1)(rd_bin_n);

  // Sync write gray into read clock domain
  sync2d #(.W(AW+1)) u_sync_wr2rd (.clk(rd_clk), .rst_n(rst_n_rd), .d(wr_gray), .q(wr_gray_rdclk));

  // Empty: next read gray equals synchronized write gray
  always_ff @(posedge rd_clk or negedge rst_n_rd) begin
    if (!rst_n_rd) begin
      rd_bin   <= '0;
      rd_empty <= 1'b1;
      rd_valid <= 1'b0;
    end else begin
      rd_bin   <= rd_bin_n;
      rd_empty <= (rd_gray_n == wr_gray_rdclk);
      rd_valid <= ram_re; // 1-cycle latency read
    end
  end
endmodule
