# n=5 model=out iset=I1 prefix14_class=6838
cmp P2, P0
cmovl S2, P0
mov S0, P3
cmovle P0, P2
cmovl P2, S2
cmp P1, P3
cmovle P3, P1
cmovl P1, S0
cmp P2, P1
cmovge S0, P1
cmovl S0, P2
cmovg P1, P2
cmp P3, P0
cmovl S2, P0
