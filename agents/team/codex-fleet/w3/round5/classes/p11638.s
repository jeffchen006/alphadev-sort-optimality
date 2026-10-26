# n=5 model=out iset=I1 prefix14_class=11638
cmp P0, P1
cmovl S2, P1
cmovge S2, P0
mov S1, S2
cmovg P0, P1
cmp P2, P3
cmovg S0, P2
cmovge P2, P3
cmovg P3, S0
cmp S2, P3
cmovl S2, P3
cmovge S1, P3
cmp P2, P0
mov P1, P0
