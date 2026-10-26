# n=5 model=out iset=I1 prefix14_class=13338
cmp P3, P1
mov S0, P3
cmovg P3, P1
cmovg P1, S0
mov S1, P3
cmp P2, P0
cmovl S0, P2
cmovl P2, P0
cmovl P0, S0
cmp P0, S1
cmovg P3, P0
cmovl S1, P0
cmp P1, P2
mov S1, P2
