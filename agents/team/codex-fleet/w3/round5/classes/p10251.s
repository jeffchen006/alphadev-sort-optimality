# n=5 model=out iset=I1 prefix14_class=10251
cmp P1, P3
mov S0, P2
cmovl S1, P1
cmovge S1, P3
cmovle P1, P3
cmp P2, P0
cmovg P2, P0
cmovl S0, P0
cmp P1, S0
cmovl P3, P1
cmovl P1, S0
cmovl S0, P3
cmp P2, S1
mov P1, P2
