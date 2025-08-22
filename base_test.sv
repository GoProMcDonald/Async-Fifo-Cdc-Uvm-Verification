import uvm_pkg::*; `include "uvm_macros.svh"
import fifo_pkg::*;
class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  env e; fifo_cfg cfg;
  function new(string name, uvm_component parent); super.new(name,parent); endfunction

  function void build_phase(uvm_phase phase);
    cfg=fifo_cfg::type_id::create("cfg");
    if (!uvm_config_db#(virtual fifo_if.WR)::get(this, "", "vif_wr", cfg.vif_wr)) `uvm_fatal("TEST","no vif_wr")
    if (!uvm_config_db#(virtual fifo_if.RD)::get(this, "", "vif_rd", cfg.vif_rd)) `uvm_fatal("TEST","no vif_rd")
    void'(uvm_config_db#(int unsigned)::get(null, "tb_top", "WR_MHZ", cfg.wr_mhz));
    void'(uvm_config_db#(int unsigned)::get(null, "tb_top", "RD_MHZ", cfg.rd_mhz));
    uvm_config_db#(fifo_cfg)::set(this, "*", "cfg", cfg);
    e = env::type_id::create("e", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    vseq_cdc_stress v = vseq_cdc_stress::type_id::create("v");
    v.start(e.vseqr_h);
    #1us; // drain
    phase.drop_objection(this);
  endtask
endclass
