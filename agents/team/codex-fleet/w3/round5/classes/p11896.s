# n=5 model=out iset=I1 prefix14_class=11896
mov S2, P2
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
cmovge P0, S0
cmp P1, P2
cmovl S2, P1
cmovg P2, P1
cmp P3, P2
mov S1, P0
cmovge P1, P3
cmovg P3, P2
cmovge P2, P1
cmp S1, S2
