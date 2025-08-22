import uvm_pkg::*; `include "uvm_macros.svh"
import txn_wr_pkg::*; import txn_rd_pkg::*;
class vseq_cdc_stress extends uvm_sequence;
  `uvm_object_utils(vseq_cdc_stress)
  vseqr vseqr_h;
  function new(string name="vseq_cdc_stress"); super.new(name); endfunction
  task body();
    if(!$cast(vseqr_h, m_sequencer)) `uvm_fatal("VSEQ","bad vseqr")
    fork
      begin seq_wr_burst w = seq_wr_burst::type_id::create("w"); w.start(vseqr_h.wr_sqr); end
      begin seq_rd_burst r = seq_rd_burst::type_id::create("r"); r.start(vseqr_h.rd_sqr); end
    join
  endtask
endclass
