# n=5 model=out iset=I1 prefix14_class=11004
cmp P0, P3
cmovl S0, P3
cmovl P3, P0
cmovl P0, S0
cmp P1, P2
mov S1, P2
cmovge S1, P1
cmovg P1, P2
mov P2, S1
cmp P2, P0
cmovle P2, P0
cmovl P0, S1
cmp P3, P1
cmovl S1, P1
