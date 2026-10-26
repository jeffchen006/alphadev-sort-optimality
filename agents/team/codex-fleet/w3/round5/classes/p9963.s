# n=5 model=out iset=I1 prefix14_class=9963
cmp P1, P0
mov S2, P1
cmovge P1, P0
cmovg P0, S2
cmp P2, P3
mov S2, P2
cmovge P2, P3
cmovge P3, S2
cmp P3, P0
cmovg S1, P3
cmovg P3, P0
cmovg P0, S1
mov P0, P1
cmp P1, P2
