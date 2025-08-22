interface fifo_if #(parameter DATA_W=32) (
  input logic wr_clk, rd_clk,
  input logic rst_n_wr, rst_n_rd
);
  // Write side
  logic              wr_en;
  logic [DATA_W-1:0] wr_data;
  logic              wr_full;
  // Read side
  logic              rd_en;
  logic [DATA_W-1:0] rd_data;
  logic              rd_valid;
  logic              rd_empty;

  // Modports
  modport WR (input wr_full, wr_clk, rst_n_wr, output wr_en, wr_data);
  modport RD (input rd_empty, rd_data, rd_valid, rd_clk, rst_n_rd, output rd_en);
  modport MON_WR (input wr_en, wr_data, wr_full, wr_clk, rst_n_wr);
  modport MON_RD (input rd_en, rd_data, rd_valid, rd_empty, rd_clk, rst_n_rd);
endinterface
