# n=5 model=out iset=I1 prefix14_class=1701
cmp P0, P1
cmovl S2, P1
cmovge S2, P0
cmovl P1, P0
mov S0, P3
cmp P2, S0
cmovl P3, P2
mov P0, P3
cmovl P2, S0
cmp P1, P3
cmovl P0, P1
cmovg P3, P1
cmp P2, S2
cmovle P0, S2
