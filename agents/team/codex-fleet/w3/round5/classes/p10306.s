# n=5 model=out iset=I1 prefix14_class=10306
mov S2, P0
cmp P2, P0
cmovge S2, P2
cmovg P2, P0
cmp P1, P3
mov P0, P3
cmovg P0, P1
cmovge P1, P3
cmp S2, P0
cmovg S0, P0
cmovge P0, S2
cmovg S2, S0
cmp P1, P2
mov P3, P1
