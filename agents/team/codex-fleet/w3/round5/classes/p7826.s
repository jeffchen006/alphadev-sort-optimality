# n=5 model=out iset=I1 prefix14_class=7826
cmp P0, P3
mov S2, P0
cmovge P0, P3
cmovg P3, S2
cmp P2, P1
cmovge S2, P2
mov S1, P0
cmovge P2, P1
cmovg P1, S2
cmp S1, P2
cmovge P0, P2
cmovl S1, P2
cmp P3, P1
cmovg P0, P3
