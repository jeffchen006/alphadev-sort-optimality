# n=5 model=out iset=I1 prefix14_class=8562
mov S1, P2
cmp P1, S1
cmovge S1, P1
cmovle P2, P1
cmp P0, P3
cmovle S0, P0
cmovle P0, P3
cmovg S0, P3
mov S2, S1
cmp S1, P0
cmovge S1, P0
cmovl S2, P0
cmp P2, S0
cmovle P0, P2
