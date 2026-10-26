# n=5 model=out iset=I1 prefix14_class=13094
mov S1, P2
cmp P0, P1
cmovge S2, P0
cmovge P0, P1
cmovl S2, P1
cmp P2, P3
cmovl S1, P3
cmovg P2, P3
cmp P2, P0
cmovge P1, P2
cmovge P2, P0
cmovg P0, P1
cmp S1, S2
cmovg P3, S2
