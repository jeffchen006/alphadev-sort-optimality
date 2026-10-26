# n=5 model=out iset=I1 prefix14_class=3434
cmp P3, P1
mov S0, P0
cmovge S2, P1
cmovg P1, P3
cmovge P3, S2
cmp S0, P2
cmovl S0, P2
cmovg P0, P2
mov S1, P3
mov P2, P1
cmp P0, P3
cmovg S1, P0
cmovge P0, P3
cmp S0, P1
