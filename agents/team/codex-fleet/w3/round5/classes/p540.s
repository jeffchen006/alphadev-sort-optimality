# n=5 model=out iset=I1 prefix14_class=540
mov S1, P2
cmp P2, P1
mov S2, P0
cmovg S1, P1
cmovg P1, P2
cmp P0, P3
cmovge S2, P3
cmovge P3, P0
mov S0, S2
cmp S1, S2
mov P0, P1
cmovge S0, S1
cmovg S1, S2
cmp P3, P0
