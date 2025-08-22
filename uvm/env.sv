import uvm_pkg::*; `include "uvm_macros.svh"
import txn_wr_pkg::*; import txn_rd_pkg::*; import fifo_pkg::*;
class env extends uvm_env;
  `uvm_component_utils(env)
  fifo_cfg cfg;
  wr_agent wag; rd_agent rag; scoreboard sb; coverage_collector cov;
  vseqr vseqr_h;
  function new(string name, uvm_component parent); super.new(name,parent); endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(fifo_cfg)::get(this, "", "cfg", cfg)) `uvm_fatal("ENV","cfg not set")
    wag = wr_agent::type_id::create("wag", this);
    rag = rd_agent::type_id::create("rag", this);
    sb  = scoreboard::type_id::create("sb", this);
    cov = coverage_collector::type_id::create("cov", this);
    vseqr_h = vseqr::type_id::create("vseqr_h", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    wag.vif_drv = cfg.vif_wr; wag.vif_mon = cfg.vif_wr;
    rag.vif_drv = cfg.vif_rd; rag.vif_mon = cfg.vif_rd;
    wag.ap_wr.connect(sb.imp_wr);
    rag.ap_rd_drv.connect(sb.imp_rd_drv);
    rag.ap_rd_mon.connect(sb.imp_rd_mon);
    uvm_config_db#(scoreboard)::set(this, "cov", "sb", sb);

    // 将时钟比率类别传给覆盖组件
    ratio_info r=new(cfg.wr_mhz, cfg.rd_mhz);
    uvm_config_db#(string)::set(this, "cov", "ratio_class", r.ratio_class());

    // 虚拟 sequencer 连接实际 sequencer
    vseqr_h.wr_sqr = wag.seqr; vseqr_h.rd_sqr = rag.seqr;
  endfunction
endclass
