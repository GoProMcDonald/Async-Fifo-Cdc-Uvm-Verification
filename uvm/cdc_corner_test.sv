import uvm_pkg::*; `include "uvm_macros.svh"
class cdc_corner_test extends base_test;
  `uvm_component_utils(cdc_corner_test)
  function new(string name, uvm_component parent); super.new(name,parent); endfunction
endclass
