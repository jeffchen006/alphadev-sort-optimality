# n=5 model=out iset=I1 prefix14_class=10328
cmp P1, P2
cmovge S2, P2
cmovg P2, P1
cmovl S2, P1
cmp P3, P0
mov S1, P0
cmovl P0, P3
cmovg S1, P3
mov S0, P0
cmp S1, P2
cmovg P3, P2
cmovg P2, S1
cmovg S1, P3
cmp S0, S2
