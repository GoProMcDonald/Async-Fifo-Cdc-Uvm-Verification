module fifo_ram #(parameter DATA_W=32, parameter DEPTH=256) (
  input  logic                 wr_clk,
  input  logic                 rd_clk,
  input  logic                 we,
  input  logic [$clog2(DEPTH)-1:0] waddr,
  input  logic [DATA_W-1:0]    wdata,
  input  logic                 re,
  input  logic [$clog2(DEPTH)-1:0] raddr,
  output logic [DATA_W-1:0]    rdata
);
  logic [DATA_W-1:0] mem [0:DEPTH-1];

  always_ff @(posedge wr_clk) 
    if (we) mem[waddr] <= wdata;

  always_ff @(posedge rd_clk) 
    if (re) rdata <= mem[raddr];
endmodule
