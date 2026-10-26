# n=5 model=out iset=I1 prefix14_class=1444
mov S1, P0
mov S0, P2
cmp P0, P1
cmovge P0, P1
cmovg P1, S1
cmp P3, S0
cmovg P2, P3
cmovg P3, S0
mov S2, P2
cmp P1, S2
cmovge P2, P1
cmovge P1, S2
cmp P3, P0
cmovge S0, P0
