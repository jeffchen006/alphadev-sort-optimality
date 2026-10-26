# n=5 model=out iset=I1 prefix14_class=9287
mov S2, P3
cmp P3, P1
cmovge S2, P1
cmovge P1, P3
cmp P2, P0
mov S1, S2
cmovge P3, P2
cmovge P2, P0
cmovg P0, P3
mov S0, P0
cmp P2, S2
cmovg S1, P2
cmovge P2, S2
cmp S0, P1
