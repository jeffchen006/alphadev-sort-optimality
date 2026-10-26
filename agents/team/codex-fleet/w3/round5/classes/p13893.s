# n=5 model=out iset=I1 prefix14_class=13893
mov S0, P2
cmp P2, P3
cmovg P2, P3
cmovg P3, S0
cmp P1, P0
cmovge S0, P0
cmovg P0, P1
cmovge P1, S0
cmp P0, P3
mov S1, P3
cmovg P3, P0
cmovge P0, S1
cmp P1, P2
cmovg P3, P2
