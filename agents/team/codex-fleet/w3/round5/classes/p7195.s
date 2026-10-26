# n=5 model=out iset=I1 prefix14_class=7195
mov S1, P3
cmp P1, P2
cmovg S0, P2
cmovg P2, P1
cmovg P1, S0
cmp P3, P0
cmovg P3, P0
cmovg P0, S1
mov S2, P3
cmp S2, P1
cmovl P3, P1
cmovg S2, P1
cmp P2, P0
cmovl S2, P2
