# pulsar-soc

Mažas SoC projektas su atviro kodo HDL įrankiais.

## Aplinka

| Kas | Kur | Versija |
|-----|-----|---------|
| OSS CAD Suite (yosys, nextpnr, iverilog, verilator, gtkwave) | `~/oss-cad-suite` | 2026-09-16 |
| Python venv su cocotb | `~/hdl-venv` | cocotb 2.1.0, Python 3.12 |
| Suderinamumo shim'ai | `~/hdl-shims` | — |

Viskas įsijungia automatiškai per `~/.zshrc`:

```sh
source ~/oss-cad-suite/environment
source ~/hdl-venv/bin/activate
export PATH="$HOME/hdl-shims:$PATH"
```

### Kam tie shim'ai

OSS CAD Suite `bin/vvp` wrapper'is priverstinai nustato `PYTHONHOME` ir
`PYTHONEXECUTABLE` į savo įtaisytą Python 3.11. Kai cocotb VPI biblioteka
įkelia venv'o Python 3.12, tas `PYTHONHOME` nusiunčia ją ieškoti stdlib į
`~/oss-cad-suite/lib/python3.12` (jo nėra) ir simuliacija krenta su
`failed to get the Python codec of the filesystem encoding`.

`~/hdl-shims/vvp` paleidžia tą patį `libexec/vvp` binarą be to python env.
`~/hdl-shims/iverilog` reikalingas todėl, kad cocotb `vvp` ieško tame pačiame
kataloge, kuriame randa `iverilog`.

Shim'ai gyvena atskirai nuo `~/hdl-venv`, tad perkūrus venv jų prarasti nereikia.

## Struktūra

| Katalogas      | Kam                                  |
|----------------|--------------------------------------|
| `rtl/`         | Verilog/SystemVerilog šaltiniai      |
| `tb/`          | cocotb testbench'ai                  |
| `sim/`         | simuliacijos Makefile'ai             |
| `constraints/` | pin/timing constraints (.pcf, .sdc)  |

## Simuliacija

cocotb Makefile'o karkasas (`sim/Makefile`):

```make
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES = $(PWD)/../rtl/mano_modulis.v
TOPLEVEL = mano_modulis
MODULE = test_mano_modulis
export PYTHONPATH := $(PWD)/../tb:$(PYTHONPATH)
include $(shell cocotb-config --makefiles)/Makefile.sim
```

Paleisti: `cd sim && make`. Bangos: `gtkwave dump.vcd`.

## Sintezė

```sh
yosys -p 'read_verilog rtl/*.v; synth_ice40 -top top -json build/top.json'
```
