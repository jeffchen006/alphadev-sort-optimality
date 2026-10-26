# n=5 model=out iset=I1 prefix14_class=5849
cmp P0, P2
cmovle S2, P0
cmovl P0, P2
cmovge S2, P2
cmp P3, P1
cmovl S1, P3
cmovle P3, P1
cmovge S1, P1
cmp S1, S2
cmovl P1, S1
cmovl S1, S2
mov S0, P0
cmovl S2, P1
mov P2, S1
