# n=5 model=out iset=I1 prefix14_class=11190
mov S2, P1
cmp P3, P2
mov S0, P2
cmovge P2, P3
cmovg P3, S0
cmp P1, P0
cmovl S2, P0
cmovl P0, P1
cmp S2, P2
cmovge S1, S2
cmovge S2, P2
cmovg P2, S1
cmp P3, P0
cmovl P1, P3
