# n=5 model=out iset=I1 prefix14_class=8390
cmp P0, P3
cmovl S2, P0
mov S0, P2
cmovl P0, P3
cmovl P3, S2
cmp S0, P1
cmovg S0, P1
cmovg P1, P2
cmovge P2, S0
cmp P1, P0
cmovl S2, P1
cmovl P1, P0
cmovl P0, S2
cmp P2, P3
