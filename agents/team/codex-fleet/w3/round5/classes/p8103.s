# n=5 model=out iset=I1 prefix14_class=8103
cmp P1, P3
cmovl S1, P1
cmovge S1, P3
cmovl P1, P3
mov S2, P0
cmp P2, S2
cmovge S2, P2
mov S0, S1
cmovg P2, P0
cmp P2, S0
cmovl S1, P2
cmovle P2, S0
cmp S2, P1
cmovl S0, P1
