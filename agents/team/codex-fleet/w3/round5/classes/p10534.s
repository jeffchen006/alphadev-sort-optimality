# n=5 model=out iset=I1 prefix14_class=10534
mov S2, P1
cmp P1, P3
mov S1, P2
cmovl P1, P3
cmovl P3, S2
cmp P0, P2
mov S0, P3
cmovg P2, P0
cmovg P0, S1
cmp P2, P1
cmovl S2, P1
cmovl P1, P2
cmovl P2, S2
cmp P0, P3
