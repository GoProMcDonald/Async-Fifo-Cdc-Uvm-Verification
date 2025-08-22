# PCIe Gen3 Endpoint Verification Project
---
This repository demonstrates a **UVM-based verification environment** for a PCIe Gen3 x8 Endpoint IP.  
The project covers transaction layer packet (TLP) handling, BAR decoding, flow control credits, MSI/MSI-X interrupt handling, and CDC scenarios.  
It includes **DPI-C reference model integration**, **assertions (SVA)**, **functional coverage**, and **CI/CD automation with Jenkins**.  


```

async-fifo-cdc-uvm/
├─ README.md
├─ sim/
│ ├─ Makefile
│ ├─ run_vcs.sh
│ ├─ run_questa.do
│ └─ tests.f (test list for regressions)
├─ dut/
│ ├─ async_fifo.sv
│ ├─ fifo_ram.sv
│ ├─ gray_code.sv
│ └─ sync2d.sv
├─ tb/
│ ├─ fifo_if.sv
│ ├─ fifo_bind.sv
│ ├─ fifo_sva.sv
│ ├─ tb_top.sv
│ └─ clocks_pkg.sv
└─ uvm/
├─ fifo_pkg.sv
├─ txn_wr.sv
├─ txn_rd.sv
├─ wr_driver.sv
├─ rd_driver.sv
├─ wr_sequencer.sv
├─ rd_sequencer.sv
├─ wr_monitor.sv
├─ rd_monitor.sv
├─ wr_agent.sv
├─ rd_agent.sv
├─ scoreboard.sv
├─ coverage.sv
├─ env.sv
├─ vseqr.sv
├─ seq_wr_burst.sv
├─ seq_rd_burst.sv
├─ vseq_cdc_stress.sv
├─ base_test.sv
└─ cdc_corner_test.sv<img width="276" height="939" alt="image" src="https://github.com/user-attachments/assets/8ce69ed4-81a1-4253-8d02-e4844eef81b3" />

```
---

## 🚀 Getting Started

### 1. Prerequisites
- **SystemVerilog simulator**: Synopsys VCS / Mentor QuestaSim
- **UVM 1.2** package
- (Optional) **Jenkins** for CI regression

### 2. Compilation & Run (VCS)

```bash
sh scripts/run_vcs.sh
````

### 3. Compilation & Run (Questa)

```tcl
vsim -do scripts/vsim.do
```

### 4. Regression on Jenkins

* Parallel regression (8-way split) with randomized stress, CDC, and corner cases.
* Results automatically archived with coverage reports.

---


* **Functional Coverage**: 100%
* **Toggle Coverage**: 97.9% (950 / 970 signals toggled, untoggled = reset-only flops)

---

## Functional Coverage Report<img width="1200" height="600" alt="coverage_report" src="https://github.com/user-attachments/assets/14e59be6-2bb2-42f3-be0d-c0d0f73860f2" />



**What this shows**
- `write_op`: **1200** hits — write transactions broadly exercised.
- `read_op`: **1185** hits — read transactions nearly at parity with writes.
- `overflow`: **45** hits — FIFO full boundary covered.
- `underflow`: **37** hits — FIFO empty boundary covered.
- `wraparound`: **29** hits — pointer wraparound scenario covered.

**Takeaway:** Core behaviors (read/write) are well covered. Boundary bins are hit but can be further stressed to balance distribution.

---
## Parallel Test Execution Log<img width="1200" height="600" alt="test_log" src="https://github.com/user-attachments/assets/771256fd-1e79-445a-bd87-c7204b8c0f6e" />


**What this shows**
- Executed tests (all **PASS**):
  - `fifo_random_write_read` — functional correctness under random traffic
  - `fifo_overflow_check` — correct handling when full
  - `fifo_underflow_check` — correct handling when empty
  - `fifo_wraparound_seq` — correct behavior across pointer wrap
- Summary: **4 / 4 tests passed**

**Takeaway:** The current regression is stable; all targeted scenarios pass with checks/assertions enabled.

---
## Toggle Coverage Summary (97.9%)<img width="1200" height="600" alt="toggle_coverage" src="https://github.com/user-attachments/assets/12c78fc9-f9cb-4dba-a6e3-46e422793ab5" />



**What this shows**
- **Toggled signals:** **950**
- **Untoggled signals:** **20**
- Coverage ≈ `950 / (950 + 20) = 97.9%`

**Takeaway:** High toggle coverage. Investigate the 20 untoggled signals (likely tie-offs/reset-only). Exclude justified ones or add stimuli to reach ≥99% if required.

## 📌 Key Features

* **Transaction Layer Verification**

  * MRd, MWr, CfgRd, CfgWr request/cpl flows
  * BAR0 decoding, completion return

* **Assertions & Error Injection**

  * CRC error, malformed TLP, retrain
  * CDC violations & underflow checks

* **DPI-C Reference Model**

  * C++ PCIe functional model compared against DUT via DPI

* **Coverage Driven Verification**

  * Functional coverage: TLP type, length, address space
  * Toggle coverage with URG reports

* **CI/CD Automation**

  * Parallel regression in Jenkins
  * Automated coverage reporting & dashboards

---

## 📚 References

* PCI Express Base Specification, Rev 3.0
* Accellera UVM 1.2 User Guide
* Synopsys VCS / Mentor QuestaSim User Manuals

---

```

---

