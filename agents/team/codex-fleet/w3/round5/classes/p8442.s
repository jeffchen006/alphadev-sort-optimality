# n=5 model=out iset=I1 prefix14_class=8442
mov S2, P3
cmp P2, P0
cmovl S1, P0
cmovge S1, P2
cmovge P2, P0
cmp P1, S2
cmovge P3, P1
cmovge P1, S2
cmp S1, P3
cmovg P0, P3
cmovge P3, S1
cmovg S1, P0
cmp P1, P2
cmovge S0, P1
