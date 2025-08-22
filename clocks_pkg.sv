package clocks_pkg;
  class ratio_info;
    rand int unsigned wr_mhz, rd_mhz;
    function new(int unsigned w=400, int unsigned r=100); wr_mhz=w; rd_mhz=r; endfunction
    function string ratio_class();
      if (wr_mhz==rd_mhz) return "1to1";
      else if (wr_mhz>rd_mhz*2) return "WR_FAST";
      else if (rd_mhz>wr_mhz*2) return "RD_FAST";
      else return "NEAR";
    endfunction
  endclass
endpackage
