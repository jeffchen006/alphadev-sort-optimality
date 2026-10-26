# n=5 model=out iset=I1 prefix14_class=9211
mov S2, P1
cmp P3, S2
cmovl S2, P3
mov S1, P2
cmovl P3, P1
cmp P0, S1
cmovl S1, P0
cmovg P2, P0
cmp S2, S1
cmovge P1, S2
cmovge S2, S1
cmovg S1, P1
mov S0, P2
cmp P3, S0
