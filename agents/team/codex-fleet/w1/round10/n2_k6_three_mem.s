# n=2 model=mem iset=I1 source=w1_partial_shapes
mov S0, P0
mov S1, P1
cmp S0, S1
cmovle S2, S1
cmovle S3, S2
cmovl S2, S3
cmovle S1, S0
mov P0, S1
cmovg S3, S0
mov P1, S3
