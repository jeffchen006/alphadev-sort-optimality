# n=5 model=out iset=I1 prefix14_class=5508
mov S1, P1
mov S0, P0
cmp P1, P3
cmovl P1, P3
cmovl P3, S1
cmp S0, P2
mov S2, P3
cmovg P0, P2
cmovl S0, P2
cmp S2, P0
cmovl S2, P0
cmovl P0, P3
cmp P1, S0
cmovg S1, S0
