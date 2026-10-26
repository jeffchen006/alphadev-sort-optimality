# n=5 model=out iset=I1 prefix14_class=1446
cmp P3, P1
mov S0, P0
cmovge S1, P3
cmovg P3, P1
cmovge P1, S1
cmp P2, P0
cmovg P0, P2
mov S2, P0
cmovg P2, S0
cmp P1, P0
mov S0, P3
cmovge P0, P1
cmovg P1, S2
cmp P2, S0
