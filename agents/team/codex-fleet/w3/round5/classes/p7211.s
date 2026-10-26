# n=5 model=out iset=I1 prefix14_class=7211
mov S0, P3
cmp P3, P0
mov S2, P1
cmovl S0, P0
cmovg P3, P0
cmp P2, P1
cmovl P1, P2
cmovg S2, P2
mov S1, P1
cmp S1, P3
cmovge S1, P3
cmovl P1, P3
cmp S2, S0
cmovl P3, S0
