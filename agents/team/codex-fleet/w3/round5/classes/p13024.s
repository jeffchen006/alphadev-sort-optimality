# n=5 model=out iset=I1 prefix14_class=13024
cmp P0, P3
cmovge S0, P0
cmovl S0, P3
cmovg P0, P3
cmp P2, P1
cmovl S1, P1
cmovge S1, P2
cmovle P1, P2
cmp P1, P0
cmovle P3, P1
cmovl P1, P0
cmovle P0, P3
cmp S0, S1
mov S2, P1
