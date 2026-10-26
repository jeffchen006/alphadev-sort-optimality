# n=5 model=out iset=I1 prefix14_class=7241
cmp P1, P0
cmovle S2, P0
cmovg S2, P1
cmovle P0, P1
cmp P3, P2
mov S1, P0
cmovl S0, P2
cmovl P2, P3
cmovge S0, P3
cmp P2, P0
cmovge S1, P2
cmovl P0, P2
cmp S2, S0
mov P0, S1
