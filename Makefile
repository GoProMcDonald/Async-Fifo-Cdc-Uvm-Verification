```make
TOOL ?= vcs
TEST ?= cdc_corner_test
WR_MHZ ?= 400
RD_MHZ ?= 100
SEED ?= 1
SIM_TIME ?= 1ms


all:
@echo "Use: make regress TOOL=vcs|questa"


# Simple regression: iterate tests & seeds from tests.f
regress:
@[ -f tests.f ] || { echo 'tests.f missing'; exit 1; }
@while read T S; do \
echo "[RUN] $$T seed=$$S"; \
if [ "$(TOOL)" = "vcs" ]; then \
./run_vcs.sh -test $$T -seed $$S; \
else \
vsim -c -do run_questa.do +UVM_TESTNAME=$$T +ntb_random_seed=$$S; \
fi; \
done < tests.f
```