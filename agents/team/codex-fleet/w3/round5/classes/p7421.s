# n=5 model=out iset=I1 prefix14_class=7421
cmp P1, P0
cmovl S1, P0
mov S2, P3
cmovge S1, P1
cmovge P1, P0
cmp P2, P3
cmovge S2, P2
cmovge P2, P3
cmp P1, P2
cmovge P3, P1
cmovg P1, P2
cmovg P2, P3
cmp S2, S1
mov P1, S2
