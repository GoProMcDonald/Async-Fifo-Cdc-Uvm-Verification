import uvm_pkg::*; `include "uvm_macros.svh"
class coverage_collector extends uvm_component;
  `uvm_component_utils(coverage_collector)
  scoreboard sb;
  string ratio_class="UNKNOWN";

  // 占用深度分层覆盖（通过 scoreboard 的样本计数近似）
  covergroup cg_flags_depth;
    option.per_instance = 1;
    cp_depth : coverpoint sb.depth_samples { 
      bins d0={0}; 
      bins mid={[1:DEPTH/2]}; 
      bins near_full={[DEPTH/2+1:DEPTH-2]}; 
      bins full={DEPTH-1}; 
    }
  endgroup

  // 时钟比率类别覆盖
  covergroup cg_ratio with function sample(string rc);
    option.per_instance = 1;
    cp_ratio: coverpoint rc { bins C1={"1to1"}; bins CW={"WR_FAST"}; bins CR={"RD_FAST"}; bins CN={"NEAR"}; }
  endgroup

  function new(string name, uvm_component parent); super.new(name,parent);
    cg_flags_depth = new; cg_ratio = new;
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(scoreboard)::get(this,"","sb", sb)) `uvm_fatal("COV","scoreboard handle not set")
    void'(uvm_config_db#(string)::get(this,"","ratio_class", ratio_class));
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @sb.ev_wr; cg_flags_depth.sample();
      cg_ratio.sample(ratio_class);
    end
  endtask
endclass
