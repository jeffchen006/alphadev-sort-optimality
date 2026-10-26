# n=2 R=4 model=out iset=I1 source=w1_partial_shapes
cmp P0, P1
cmovle S0, P1
cmovle S1, S0
cmovl S0, S1
cmovle P1, P0
out 0, P1
cmovg S1, P0
out 1, S1
