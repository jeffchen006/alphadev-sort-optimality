# n=5 model=out iset=I1 prefix14_class=1443
mov S1, P0
cmp S1, P1
mov S0, P2
cmovge S1, P1
cmovg P1, P0
cmp P3, S0
cmovg S0, P3
cmovg P3, P2
mov S2, P1
cmp S0, P1
cmovg S2, S0
cmovge S0, P1
cmp P3, S1
cmovge P2, S1
