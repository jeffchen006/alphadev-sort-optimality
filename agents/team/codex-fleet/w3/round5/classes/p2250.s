# n=5 model=out iset=I1 prefix14_class=2250
mov S1, P1
cmp P1, P2
cmovg P1, P2
cmovl S1, P2
cmp P3, P0
mov S0, P0
cmovg S0, P3
mov S2, S0
cmovg P3, P0
cmp S0, S1
cmovl S2, S1
cmovl S1, S0
cmp P1, P3
cmovl S0, P1
