# n=5 model=out iset=I1 prefix14_class=2009
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
cmovge P1, S1
mov S2, P2
cmp S2, P0
cmovge P2, P0
cmovl S2, P0
mov P0, S2
cmp P3, S2
cmovge P0, P3
mov S0, P2
cmovge P3, S2
cmp P1, P2
