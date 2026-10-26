# n=5 model=out iset=I1 prefix14_class=9230
cmp P2, P1
cmovge S0, P1
cmovg P1, P2
cmovge P2, S0
mov S2, P3
mov S1, P2
cmp P0, S2
cmovge P3, P0
cmovl S2, P0
cmp S1, S2
cmovl P2, S2
cmovge S1, S2
cmp P1, P3
cmovl S2, P1
