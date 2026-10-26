# n=5 model=out iset=I1 prefix14_class=3331
mov S0, P1
cmp P3, P2
mov S1, P3
cmovg S1, P2
cmovge P2, P3
cmp S0, P0
cmovg S0, P0
cmovg P0, P1
cmp S0, S1
cmovge S2, S0
cmovg S0, S1
mov P1, P0
cmovg S1, S2
cmp P0, P2
