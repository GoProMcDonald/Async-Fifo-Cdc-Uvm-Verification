# =========================================================
# QuestaSim DO file
# =========================================================

vlib work
vmap work work

# 编译文件列表
vlog -sv -timescale 1ns/1ps -f sim/tests.f

# 启动仿真
vsim -c tb_top -do "run -all; quit"
