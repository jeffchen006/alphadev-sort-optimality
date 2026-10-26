# n=5 model=out iset=I1 prefix14_class=6359
cmp P2, P1
cmovge S1, P2
cmovg P2, P1
cmovg P1, S1
cmp P0, P3
mov S2, P0
cmovge S2, P3
mov S0, P1
cmovge P3, P0
cmp P3, P1
cmovge P1, P3
cmovl S0, P3
cmp S2, P2
mov P3, S2
