# cocotb + Verilator testas modului and2
SIM ?= verilator
TOPLEVEL_LANG ?= verilog

ROOT := $(abspath $(CURDIR)/../..)
VERILOG_SOURCES = $(ROOT)/sandbox/and2.sv
COCOTB_TOPLEVEL = and2
COCOTB_TEST_MODULES = test_and2

# Bangų formos (dump.vcd) – visada
VERILATOR_TRACE ?= 1
EXTRA_ARGS += --timing

include $(shell cocotb-config --makefiles)/Makefile.sim
