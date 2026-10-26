# n=5 model=out iset=I1 prefix14_class=1445
mov S0, P2
cmp P1, P0
cmovge S1, P1
cmovg P1, P0
cmovg P0, S1
cmp P3, S0
cmovg P2, P3
mov S2, P2
cmovge P3, S0
mov S0, P1
cmp P0, S2
cmovg P2, P0
cmovg P0, S2
cmp P3, P1
