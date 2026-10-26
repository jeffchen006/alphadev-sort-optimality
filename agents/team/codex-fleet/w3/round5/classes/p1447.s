# n=5 model=out iset=I1 prefix14_class=1447
cmp P2, P3
mov S1, P2
cmovg S1, P3
cmovge P3, P2
mov P2, P0
cmp P1, P0
cmovge P0, P1
cmovge P1, P2
cmp P3, P0
mov S0, S1
cmovg P2, P0
cmovge P0, P3
cmovg P3, P2
cmp P1, S1
