# n=5 model=out iset=I1 prefix14_class=11612
cmp P0, P3
cmovg S2, P0
mov S1, P1
cmovge P0, P3
cmovg P3, S2
cmp P2, S1
cmovg S1, P2
cmovge P2, P1
cmp S1, P3
cmovge S0, P3
cmovge P3, S1
mov P1, P0
cmovg S1, S0
cmp P2, P1
