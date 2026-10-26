# n=5 model=out iset=I1 prefix14_class=14109
mov S1, P0
cmp P2, P0
mov S2, P1
cmovl P0, P2
cmovge S1, P2
cmp P3, P1
cmovg S2, P3
cmovle P1, P3
cmp S2, S1
cmovl S0, S2
cmovl S2, S1
cmovl S1, S0
cmp P1, P0
cmovg P3, P0
