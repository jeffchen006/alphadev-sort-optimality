# n=5 model=out iset=I1 prefix14_class=11541
mov S2, P1
cmp P2, P3
cmovl S1, P3
cmovl P3, P2
cmovl P2, S1
cmp S2, P0
cmovl P1, P0
cmovle P0, S2
cmp P0, P3
cmovge S0, P0
cmovg P0, P3
cmovl S0, P3
cmp P2, P1
cmovg S1, P2
