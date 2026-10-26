# n=5 model=out iset=I1 prefix14_class=7356
mov S1, P0
cmp P1, P0
cmovg P0, P1
cmovl S1, P1
cmp P2, P3
mov S0, P2
cmovle S0, P3
cmovle P3, P2
cmp P3, S1
cmovge S2, P3
cmovl S2, S1
cmovle S1, P3
cmp S0, P0
cmovg S1, P0
