# n=5 model=out iset=I1 prefix14_class=9268
cmp P2, P0
cmovge S2, P0
cmovg P0, P2
mov S1, P3
cmovg P2, S2
cmp P1, P3
cmovge P3, P1
cmovl S1, P1
cmovl P1, P3
cmp S1, P2
cmovg S0, P2
cmovge P2, S1
cmovg S1, S0
cmp P1, P0
