# pulsar-soc: lint / sintezė / schemos / cocotb testai / bangos
#   make <taikinys> TOP=<modulis>     (pvz. make test TOP=mux4)

TOP    ?= and2
VENV   := $(CURDIR)/.venv
SCHEM  := schem
TBDIR  := tb/$(TOP)

# Modulio failas: pirma rtl/, tada sandbox/
SRC := $(firstword $(wildcard rtl/$(TOP).sv sandbox/$(TOP).sv))

# Testams – projekto .venv (ne ~/hdl-venv iš .zshrc)
export VIRTUAL_ENV := $(VENV)
export PATH := $(VENV)/bin:$(PATH)

define need_tool
	@command -v $(1) >/dev/null 2>&1 || { echo "KLAIDA: nerastas įrankis '$(1)'. $(2)"; exit 1; }
endef

define need_src
	@test -n "$(SRC)" || { echo "KLAIDA: nerastas nei rtl/$(TOP).sv, nei sandbox/$(TOP).sv"; exit 1; }
endef

.PHONY: help lint synth schem-rtl schem-gates schem test waves clean

help:
	@echo "make lint|synth|schem-rtl|schem-gates|schem|test|waves|clean TOP=<modulis>  (dabar TOP=$(TOP))"

lint:
	$(call need_src)
	$(call need_tool,verilator,Ar įjungtas ~/oss-cad-suite/environment?)
	verilator --lint-only -Wall --top-module $(TOP) $(SRC)
	@echo "OK: lint $(SRC)"

synth:
	$(call need_src)
	$(call need_tool,yosys,Ar įjungtas ~/oss-cad-suite/environment?)
	yosys -q -p "read_verilog -sv $(SRC); synth -top $(TOP); check -assert; tee -o /dev/stdout stat"

schem-rtl:
	$(call need_src)
	$(call need_tool,yosys,Ar įjungtas ~/oss-cad-suite/environment?)
	$(call need_tool,netlistsvg,Įdiek: npm install -g netlistsvg)
	@mkdir -p $(SCHEM)
	yosys -q -p "read_verilog -sv $(SRC); hierarchy -top $(TOP); proc; opt; write_json $(SCHEM)/$(TOP)_rtl.json"
	netlistsvg $(SCHEM)/$(TOP)_rtl.json -o $(SCHEM)/$(TOP)_rtl.svg
	@echo "OK: $(SCHEM)/$(TOP)_rtl.svg"

schem-gates:
	$(call need_src)
	$(call need_tool,yosys,Ar įjungtas ~/oss-cad-suite/environment?)
	$(call need_tool,netlistsvg,Įdiek: npm install -g netlistsvg)
	@mkdir -p $(SCHEM)
	yosys -q -p "read_verilog -sv $(SRC); synth -top $(TOP); write_json $(SCHEM)/$(TOP)_gates.json"
	netlistsvg $(SCHEM)/$(TOP)_gates.json -o $(SCHEM)/$(TOP)_gates.svg
	@echo "OK: $(SCHEM)/$(TOP)_gates.svg"

schem: schem-rtl schem-gates

test:
	@test -f $(TBDIR)/Makefile || { echo "KLAIDA: nėra $(TBDIR)/Makefile (sukurk tb/$(TOP)/ su Makefile ir test_$(TOP).py)"; exit 1; }
	@test -x $(VENV)/bin/cocotb-config || { echo "KLAIDA: .venv be cocotb. Paleisk: python3.12 -m venv .venv && .venv/bin/pip install 'cocotb>=2,<3'"; exit 1; }
	$(call need_tool,verilator,Ar įjungtas ~/oss-cad-suite/environment?)
	$(MAKE) -C $(TBDIR)

waves:
	$(call need_tool,surfer,Įdiek: brew install surfer)
	@test -d $(TBDIR) || { echo "KLAIDA: nėra aplanko $(TBDIR)/"; exit 1; }
	@f=$$(find $(TBDIR) \( -name 'dump.fst' -o -name 'dump.vcd' \) -exec stat -f '%m %N' {} + | sort -rn | head -1 | cut -d' ' -f2-); \
	test -n "$$f" || { echo "KLAIDA: $(TBDIR)/ nėra dump.fst/dump.vcd – pirma make test TOP=$(TOP)"; exit 1; }; \
	echo "Atidaromas $$f"; (surfer "$$f" >/dev/null 2>&1 &)

clean:
	rm -rf $(SCHEM) $(TBDIR)/sim_build $(TBDIR)/results.xml $(TBDIR)/dump.* $(TBDIR)/__pycache__
