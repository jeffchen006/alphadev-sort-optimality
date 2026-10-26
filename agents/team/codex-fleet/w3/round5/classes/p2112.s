# n=5 model=out iset=I1 prefix14_class=2112
cmp P0, P1
cmovge S1, P1
cmovg P1, P0
cmovl S1, P0
mov S2, P2
cmp S2, P3
cmovl P2, P3
cmovg S2, P3
cmp P1, P2
cmovge S0, P2
cmovg P2, P1
cmovg P1, S0
cmp S2, S1
cmovge P2, S2
