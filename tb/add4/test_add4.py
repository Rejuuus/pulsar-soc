import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def add4_exhaustive(dut):
    for a in range(16):              # a: 0..15, visos 4 bitų reikšmės
        for b in range(16):          # b: 0..15
            for cin in range(2):     # cin: 0 arba 1

                # 1. Paduodam įėjimus
                dut.a.value = a
                dut.b.value = b
                dut.cin.value = cin

                # 2. Leidžiam grandinei sureaguoti
                await Timer(1, unit="ns")

                # 3. Teisingas atsakymas (Python)
                expected = a + b + cin

                # 4. Grandinės atsakymas: cout yra 5-as bitas, jo svoris 2^4 = 16
                got = int(dut.cout.value) * 16 + int(dut.sum.value)

                # 5. Palyginimas
                assert got == expected, (
                    f"a={a} b={b} cin={cin}: laukta {expected}, gauta {got} "
                    f"(cout={int(dut.cout.value)}, sum={int(dut.sum.value)})"
                )