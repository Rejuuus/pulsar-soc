"""Aplinkos patikrinimo testas: and2 tiesos lentelė."""

import itertools

import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def and2_truth_table(dut):
    for a, b in itertools.product((0, 1), repeat=2):
        dut.a.value = a
        dut.b.value = b
        await Timer(10, unit="ns")
        assert dut.y.value == (a & b), f"a={a} b={b}: y={dut.y.value}"
