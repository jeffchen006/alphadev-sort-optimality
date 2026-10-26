# n=5 model=out iset=I1 prefix14_class=10974
cmp P3, P1
cmovl S1, P3
cmovl P3, P1
cmovl P1, S1
mov S0, P0
cmp P2, P0
mov S2, P3
cmovg P0, P2
cmovl S0, P2
cmp P0, P3
cmovge S2, P0
cmovl P3, P0
cmp P1, S0
cmovle P0, S0
