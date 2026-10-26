# n=2 model=mem iset=I1 source=w1_partial_shapes
mov S0, P0
mov S1, P1
cmp S0, S1
cmovg S2, S0
cmovg S3, S2
cmovg S4, S3
cmovg S0, S1
mov P0, S0
cmovg S1, S4
mov P1, S1
