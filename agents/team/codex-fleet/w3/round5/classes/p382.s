# n=5 model=out iset=I1 prefix14_class=382
mov S1, P0
cmp P2, P1
cmovge S2, P1
cmovl S2, P2
cmovl P2, P1
cmp P0, P3
cmovle P0, P3
cmovg S1, P3
cmovge P3, P0
cmp S2, S1
cmovge S0, S1
cmovle S0, S2
cmovl S2, S1
mov S1, S2
