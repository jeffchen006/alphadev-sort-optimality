# n=3 iset=I0 model=out source=critic/bf.cpp (logs/n3_snapshot_I0.log) k=11
cmp P0, P1
cmovl S0, P0
cmovl P0, P1
cmovl P1, S0
cmp P0, P2
cmovg S0, P2
cmovg P2, P0
out 2, P2
cmovg P0, S0
cmp P0, P1
cmovl P0, P1
out 1, P0
cmovl P1, S0
out 0, P1
