# n=5 model=out iset=I1 prefix14_class=89
mov S1, P3
mov S2, P1
cmp P0, P1
cmovge P1, P0
cmovge P0, S2
cmp P2, P3
cmovl S1, P2
cmovg P3, P2
mov S2, P3
cmp S1, P0
cmovg P2, S1
cmovge S1, P0
cmovg P0, P2
cmp S2, P1
