# n=5 model=out iset=I1 prefix14_class=12282
mov S2, P2
cmp P0, P2
cmovl S2, P0
cmovge P2, P0
cmp P1, P3
cmovge P0, P3
cmovge P3, P1
cmovg P1, P0
mov S1, S2
cmp S1, P1
cmovge S1, P1
cmovg P1, S2
cmp P3, P2
mov S1, P2
