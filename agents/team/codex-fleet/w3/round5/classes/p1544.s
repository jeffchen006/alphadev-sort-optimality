# n=5 model=out iset=I1 prefix14_class=1544
mov S1, P2
cmp P2, P3
cmovg S1, P3
cmovge P3, P2
mov S0, P1
cmovg P2, S1
cmp P1, P0
cmovge S0, P0
cmovge P0, P1
cmp P2, S0
cmovg S1, S0
cmovg S0, P2
cmp P3, P0
mov P2, P3
