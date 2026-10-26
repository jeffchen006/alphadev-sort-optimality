# n=5 model=out iset=I1 prefix14_class=11339
cmp P3, P0
cmovl S2, P0
cmovl P0, P3
cmovl P3, S2
cmp P1, P2
cmovl S1, P2
cmovge S1, P1
cmovg P1, P2
cmp S1, P3
cmovle P2, S1
cmovl S1, P3
cmovle P3, P2
mov S0, P1
cmp P0, P1
