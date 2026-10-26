# n=5 model=out iset=I1 prefix14_class=9966
cmp P1, P0
mov S2, P1
cmovge P1, P0
cmovge P0, S2
cmp P2, P3
mov S1, P2
cmovg P2, P3
cmovge P3, S1
cmp P0, P3
cmovg S2, P0
cmovg P0, P3
cmovg P3, S2
mov S0, P0
cmp P1, P2
