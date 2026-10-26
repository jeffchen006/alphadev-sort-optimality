# n=5 model=out iset=I1 prefix14_class=3271
cmp P1, P0
cmovge S2, P1
cmovg P1, P0
cmovge P0, S2
cmp P3, P2
mov S0, P2
cmovg P2, P3
cmovge P3, S0
cmovg S0, P2
mov S1, P3
cmp S1, P1
cmovge S1, P1
cmovge P1, P3
cmovle P3, P1
