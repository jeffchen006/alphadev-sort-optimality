# n=5 model=out iset=I1 prefix14_class=11614
cmp P3, P2
cmovge S0, P3
mov S1, P0
cmovge P3, P2
cmovg P2, S0
cmp P1, P0
cmovg P0, P1
cmovg P1, S1
cmp P0, P2
cmovge S0, P2
cmovg P2, P0
mov S2, P3
cmovge P0, S0
cmp P1, P3
