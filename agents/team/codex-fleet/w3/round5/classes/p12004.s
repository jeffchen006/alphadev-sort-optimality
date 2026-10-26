# n=5 model=out iset=I1 prefix14_class=12004
cmp P0, P2
mov S0, P2
cmovg P2, P0
cmovl S0, P0
cmp P1, P3
cmovge S1, P1
cmovl S1, P3
cmovle P3, P1
cmp P3, S0
cmovl P0, S0
cmovl S0, P3
mov S2, S1
cmovl P3, P0
cmp P2, S2
