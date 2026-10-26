# n=5 model=out iset=I1 prefix14_class=3272
mov S0, P3
cmp P1, P0
cmovg S2, P1
cmovge P1, P0
cmovg P0, S2
cmp P2, S0
cmovge S0, P2
cmovg P2, P3
mov S1, P2
cmovg P3, S0
cmp P2, P1
cmovg P2, P1
cmovg P1, S1
cmp S0, P0
