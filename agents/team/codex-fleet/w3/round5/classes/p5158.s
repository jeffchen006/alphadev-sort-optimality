# n=5 model=out iset=I1 prefix14_class=5158
cmp P2, P3
cmovl S0, P2
cmovl P2, P3
cmovl P3, S0
cmp P1, P0
mov S0, P0
cmovl P0, P1
cmovle P1, S0
cmp P0, P3
mov S2, P0
cmovge S2, P3
cmovg P3, P0
cmp P1, P2
cmovg P0, P2
