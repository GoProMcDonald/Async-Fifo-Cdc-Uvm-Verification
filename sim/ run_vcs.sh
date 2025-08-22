
# =========================================================
# VCS compile & run script
# =========================================================

set -e

TOP=tb_top
TEST=async_fifo_test

vcs -sverilog -full64 -ntb_opts uvm-1.2 -timescale=1ns/1ps \
    -f sim/tests.f \
    -top $TOP -l sim/vcs_compile.log

./simv +UVM_TESTNAME=$TEST -l sim/vcs_run.log
