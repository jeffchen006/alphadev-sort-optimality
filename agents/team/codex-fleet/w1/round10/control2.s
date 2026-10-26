# n=2 R=5 model=out iset=I1 source=w1_partial_shapes
cmp P0, P1
cmovg S0, P0
cmovg S1, S0
cmovg S2, S1
cmovg P0, P1
out 0, P0
cmovg P1, S2
out 1, P1
