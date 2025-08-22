module fifo_sva #(parameter DATA_W=32) (fifo_if.MON_WR wr, fifo_if.MON_RD rd);
  // 1) full/empty 互斥
  property p_flags_mutex; !(wr.wr_full && rd.rd_empty); endproperty
  a_flags_mutex: assert property (p_flags_mutex);

  // 2) 满时禁止写（写域）
  property p_no_write_on_full; @(posedge wr.wr_clk) disable iff (!wr.rst_n_wr)
    !(wr.wr_en && wr.wr_full);
  endproperty
  a_no_write_on_full: assert property (p_no_write_on_full);

  // 3) 空时禁止读（读域）
  property p_no_read_on_empty; @(posedge rd.rd_clk) disable iff (!rd.rst_n_rd)
    !(rd.rd_en && rd.rd_empty);
  endproperty
  a_no_read_on_empty: assert property (p_no_read_on_empty);

  // 4) 读有效时必须非空（1-cycle 模型）
  property p_rd_valid_latency; @(posedge rd.rd_clk) disable iff(!rd.rst_n_rd)
    rd.rd_valid |-> !rd.rd_empty;
  endproperty
  a_rd_valid_latency: assert property (p_rd_valid_latency);

  // 覆盖点
  c_full:  cover property (@(posedge wr.wr_clk) wr.wr_full);
  c_empty: cover property (@(posedge rd.rd_clk) rd.rd_empty);
endmodule
