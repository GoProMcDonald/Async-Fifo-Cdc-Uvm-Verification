`ifndef FIFO_PKG_SV
`define FIFO_PKG_SV
`include "uvm_macros.svh"
package fifo_pkg;
  import uvm_pkg::*;
  typedef enum {TX_WR, TX_RD} txn_kind_e;

  // 环境配置：虚接口 + 时钟配置
  class fifo_cfg extends uvm_object;
    `uvm_object_utils(fifo_cfg)
    virtual fifo_if.WR vif_wr;
    virtual fifo_if.RD vif_rd;
    int unsigned wr_mhz=400, rd_mhz=100;
    function new(string name="fifo_cfg"); super.new(name); endfunction
  endclass
endpackage
`endif
