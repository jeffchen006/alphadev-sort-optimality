# n=5 model=out iset=I1 prefix14_class=5727
cmp P2, P1
cmovge S1, P2
cmovg P2, P1
cmovg P1, S1
cmp P0, P3
mov S0, P1
mov S2, P3
cmovge P3, P0
cmovg P0, S2
cmp P0, P2
cmovge S1, P0
cmovg P0, P2
cmovge P2, S1
cmp P3, P1
