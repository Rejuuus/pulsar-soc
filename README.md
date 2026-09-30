# pulsar-soc

Mažas SoC projektas su atviro kodo HDL įrankiais.

## Aplinka

- **OSS CAD Suite** (yosys, nextpnr, iverilog, verilator, gtkwave) — `~/oss-cad-suite`
- **Python venv** su cocotb — `~/hdl-venv`

Abu įsijungia automatiškai per `~/.zshrc`.

## Struktūra

| Katalogas      | Kam                                  |
|----------------|--------------------------------------|
| `rtl/`         | Verilog/SystemVerilog šaltiniai      |
| `tb/`          | cocotb testbench'ai                  |
| `sim/`         | simuliacijos Makefile'ai             |
| `constraints/` | pin/timing constraints (.pcf, .sdc)  |

## Simuliacija

```sh
cd sim && make
```
