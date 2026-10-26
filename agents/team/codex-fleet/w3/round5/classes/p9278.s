# n=5 model=out iset=I1 prefix14_class=9278
mov S2, P3
cmp P2, P3
cmovge S2, P2
cmovg P2, P3
mov P3, S2
cmp P0, P1
cmovge S1, P0
cmovg P0, P1
cmovg P1, S1
cmp P2, P0
cmovge S0, P0
cmovge P0, P2
cmovg P2, S0
cmp P3, P1
