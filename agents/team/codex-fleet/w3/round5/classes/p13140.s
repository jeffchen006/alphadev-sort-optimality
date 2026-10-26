# n=5 model=out iset=I1 prefix14_class=13140
cmp P2, P3
mov S2, P2
cmovg S2, P3
cmovl P2, P3
cmp P0, P1
cmovl S0, P0
mov S1, S2
cmovl P0, P1
cmovl P1, S0
cmp S1, P1
cmovg S2, P1
cmovg P1, S1
mov S2, P0
cmp S2, P2
