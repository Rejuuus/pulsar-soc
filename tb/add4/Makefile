# cocotb + Verilator testas modului and2
SIM ?= verilator
TOPLEVEL_LANG ?= verilog

ROOT := $(abspath $(CURDIR)/../..)
VERILOG_SOURCES = $(ROOT)/rtl/add4.sv
COCOTB_TOPLEVEL = add4
COCOTB_TEST_MODULES = test_add4

# Bangų formos (dump.vcd) – visada
VERILATOR_TRACE ?= 1
EXTRA_ARGS += --timing

include $(shell cocotb-config --makefiles)/Makefile.sim
