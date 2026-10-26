# n=5 model=out iset=I1 prefix14_class=9284
cmp P3, P2
mov S2, P3
cmovge P3, P2
cmovge P2, S2
cmp P1, P0
cmovge S2, P1
cmovg P1, P0
cmovge P0, S2
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
mov S0, P2
cmovg P1, S1
cmp P2, P0
