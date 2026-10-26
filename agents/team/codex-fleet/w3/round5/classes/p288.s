# n=5 model=out iset=I1 prefix14_class=288
cmp P3, P0
mov S2, P1
cmovge S1, P3
cmovg P3, P0
cmovg P0, S1
mov S0, P0
cmp P2, P1
cmovl P1, P2
cmovge S2, P2
cmp P1, P3
cmovl S1, P3
cmovle P3, P1
cmovl P1, S1
cmp S2, P0
