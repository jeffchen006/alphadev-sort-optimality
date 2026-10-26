# n=5 model=out iset=I1 prefix14_class=11566
mov S2, P2
mov S0, P1
cmp P3, P2
cmovg P2, P3
cmovl S2, P3
cmp P0, S0
cmovl P1, P0
cmovl P0, S0
cmp P1, S2
cmovle P3, S2
cmovl S2, P1
cmovl P1, P3
mov S0, P2
cmp P0, P2
