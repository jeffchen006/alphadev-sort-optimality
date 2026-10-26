# n=5 model=out iset=I1 prefix14_class=9267
cmp P2, P0
cmovge S2, P0
mov S1, P3
cmovge P0, P2
cmovge P2, S2
cmp P1, P3
cmovge P3, P1
cmovl S1, P1
mov P1, P3
cmp S1, P2
cmovg S2, P2
cmovge P2, S1
cmovg S1, S2
cmp P1, P0
