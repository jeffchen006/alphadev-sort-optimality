# n=5 model=out iset=I1 prefix14_class=11610
cmp P2, P0
mov S2, P1
cmovge S0, P2
cmovg P2, P0
cmovge P0, S0
cmp P3, P1
cmovg S2, P3
cmovge P3, P1
cmp S2, P0
cmovge S1, P0
cmovg P0, S2
mov P1, P2
cmovge S2, S1
cmp P3, P2
