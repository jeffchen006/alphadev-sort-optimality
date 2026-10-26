# n=5 model=out iset=I1 prefix14_class=7436
cmp P3, P0
mov S1, P0
mov S2, P1
cmovg S1, P3
cmovg P3, P0
cmp P2, S2
cmovge S2, P2
mov S0, P3
cmovg P2, P1
cmp S0, P2
cmovge S0, P2
cmovge P2, P3
cmp S1, S2
cmovge P0, S1
