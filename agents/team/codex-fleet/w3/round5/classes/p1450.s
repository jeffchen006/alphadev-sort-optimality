# n=5 model=out iset=I1 prefix14_class=1450
mov S1, P0
cmp P0, P3
cmovge S1, P3
cmovg P3, P0
mov P0, P2
cmp P1, P2
cmovge P2, P1
cmovg P1, P0
cmp P3, P2
mov P0, P2
cmovge P2, P3
cmovge P3, P0
cmp P1, S1
cmovge S2, P1
