package gray_code_pkg;
  // 二进制转格雷码
  function automatic logic [W-1:0] bin2gray #(int W=1) (input logic [W-1:0] b);
    return (b >> 1) ^ b;
  endfunction

  // 格雷码转二进制
  function automatic logic [W-1:0] gray2bin #(int W=1) (input logic [W-1:0] g);
    logic [W-1:0] b;
    for (int i=W-1; i>=0; i--) begin
      b[i] = ^g[W-1:i];
    end
    return b;
  endfunction
endpackage
