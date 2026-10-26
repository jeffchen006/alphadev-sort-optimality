# n=5 model=out iset=I1 prefix14_class=2219
cmp P2, P0
mov S2, P3
mov S0, P0
cmovg P0, P2
cmovg P2, S0
cmp P1, S2
cmovg P3, P1
mov S1, P3
cmovg P1, S2
cmp S1, P0
cmovl S1, P0
mov S1, P2
cmovl P0, P3
cmp P1, P2
