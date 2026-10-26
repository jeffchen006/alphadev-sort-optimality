# n=5 model=out iset=I1 prefix14_class=12661
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
cmovl S1, P0
cmp P3, P2
cmovl S2, P3
cmovge S2, P2
cmovl P3, P2
mov S0, S2
cmp P1, S2
cmovg S2, P1
cmovge P1, S0
cmp S1, P3
cmovg P2, S1
