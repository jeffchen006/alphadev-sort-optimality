# n=5 model=out iset=I1 prefix14_class=3279
mov S2, P1
cmp P1, P3
cmovge S2, P3
cmovge P3, P1
cmp P0, P2
mov S1, P2
cmovge P2, P0
cmovg P0, S1
mov P1, P0
cmp P1, S2
cmovg P0, S2
cmovg S2, P1
mov P1, P3
cmp P3, P2
