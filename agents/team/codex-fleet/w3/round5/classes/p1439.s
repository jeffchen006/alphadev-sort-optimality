# n=5 model=out iset=I1 prefix14_class=1439
mov S0, P3
mov S1, P1
cmp S1, P0
cmovg P1, P0
cmovg P0, S1
cmp P2, S0
cmovge P3, P2
cmovg P2, S0
mov S0, P0
cmp P3, P0
cmovge S0, P3
cmovge P3, P0
cmp P2, P1
cmovge S0, P1
