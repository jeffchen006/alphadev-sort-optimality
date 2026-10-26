# n=5 model=out iset=I1 prefix14_class=13170
cmp P1, P3
cmovge S2, P1
mov S1, P2
cmovge P1, P3
cmovg P3, S2
cmp P0, S1
mov S0, P1
cmovge P2, P0
cmovge P0, S1
cmp P0, P1
cmovg P1, P0
cmovg P0, S0
cmp P2, P3
cmovg S0, P3
