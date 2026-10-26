# n=5 model=out iset=I1 prefix14_class=8817
cmp P0, P1
mov S2, P0
cmovge S2, P1
cmovge P1, P0
mov S0, P2
cmp S0, P3
cmovg S0, P3
cmovg P3, P2
cmp P3, P1
cmovg P0, P1
cmovge P1, P3
mov S1, S0
cmovg P3, P0
cmp S2, S0
