# n=5 model=out iset=I1 prefix14_class=1562
mov S1, P2
cmp P3, S1
cmovg S1, P3
cmovge P3, P2
mov S0, P1
cmp P1, P0
cmovge P1, P0
cmovl S0, P0
mov P2, P3
cmp P3, P1
cmovge P3, P1
cmovg P1, P2
cmp S0, S1
cmovge S2, S1
