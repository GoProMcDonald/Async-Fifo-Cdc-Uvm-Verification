bind tb_top.fifoi fifo_sva #(.DATA_W(tb_top.DATA_W)) u_fifo_sva (.wr(tb_top.fifoi), .rd(tb_top.fifoi));
