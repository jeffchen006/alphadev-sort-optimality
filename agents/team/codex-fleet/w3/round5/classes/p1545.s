# n=5 model=out iset=I1 prefix14_class=1545
cmp P3, P2
cmovg S1, P2
cmovge P2, P3
mov S2, P1
cmovg P3, S1
cmp P1, P0
cmovg S2, P0
mov S1, P3
cmovge P0, P1
cmp P3, S2
cmovg S1, S2
cmovg S2, P3
cmp P0, P2
mov P3, P0
