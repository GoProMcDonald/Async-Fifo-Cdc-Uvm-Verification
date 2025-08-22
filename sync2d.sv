module sync2d #(parameter W=1) (
  input  logic clk,
  input  logic rst_n,
  input  logic [W-1:0] d,
  output logic [W-1:0] q
);
  logic [W-1:0] q1;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin 
      q1 <= '0; 
      q  <= '0; 
    end
    else begin 
      q1 <= d; 
      q  <= q1; 
    end
  end
endmodule
