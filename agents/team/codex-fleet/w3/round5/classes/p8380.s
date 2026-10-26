# n=5 model=out iset=I1 prefix14_class=8380
mov S2, P0
cmp P0, P3
mov S0, P2
cmovl P0, P3
cmovl P3, S2
cmp S0, P1
cmovg S0, P1
cmovg P1, P2
mov P2, S0
cmp P0, P1
cmovl S1, P0
cmovl P0, P1
cmovl P1, S1
cmp P2, P3
