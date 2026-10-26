# n=2 iset=I1 model=out source=w12_C1_control
mov S1, S0
cmp S0, P0
cmp P0, P1
cmovg S0, P1
cmovg S1, P1
cmp P0, P1
mov S2, P0
cmovg P0, P1
cmovg P1, S2
out 0, P0
out 1, P1
