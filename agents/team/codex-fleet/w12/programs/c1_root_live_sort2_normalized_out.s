# n=2 iset=I1 model=out source=w12_C1_control
cmp P0, P1
mov S0, P0
cmovg S0, P1
mov S1, P0
cmovg S1, P1
cmp P0, P1
mov S2, P0
cmovg S2, P1
cmovg P1, P0
out 0, S2
out 1, P1
