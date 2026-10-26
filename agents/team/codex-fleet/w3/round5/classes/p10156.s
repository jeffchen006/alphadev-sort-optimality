# n=5 model=out iset=I1 prefix14_class=10156
cmp P3, P0
mov S1, P3
cmovge S1, P0
cmovg P0, P3
mov S2, P2
cmp P1, P2
cmovg S2, P1
cmovge P1, P2
cmp S2, P0
cmovge S0, P0
cmovg P0, S2
cmovge S2, S0
mov P3, S1
mov P2, S2
