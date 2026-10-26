# n=5 model=out iset=I1 prefix14_class=7952
cmp P3, P1
mov S2, P1
mov S1, P0
cmovg S2, P3
cmovge P3, P1
cmp S1, P2
cmovge S1, P2
cmovg P2, P0
cmp P3, S1
cmovge P1, S1
mov S0, P2
cmovg S1, P3
cmovge P3, P1
cmp P2, S2
