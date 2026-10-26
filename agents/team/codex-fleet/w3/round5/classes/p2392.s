# n=5 model=out iset=I1 prefix14_class=2392
mov S0, P3
cmp P3, P0
mov S1, P2
cmovg P3, P0
cmovg P0, S0
cmp P2, P1
cmovl S1, P1
cmovl P1, P2
cmp P0, S1
cmovl S0, P0
cmovl P0, S1
cmovl S1, S0
mov P0, P3
cmp P0, P1
