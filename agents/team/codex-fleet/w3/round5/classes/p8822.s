# n=5 model=out iset=I1 prefix14_class=8822
mov S2, P2
mov S0, P0
cmp S2, P1
cmovge S2, P1
cmovge P1, P2
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
cmp P1, P3
mov S1, S0
cmovge P0, P3
cmovg P3, P1
cmovge P1, P0
cmp S2, S1
