# n=5 model=out iset=I1 prefix14_class=9272
mov S1, P1
cmp P3, P1
cmovge S1, P3
cmovg P3, P1
cmp P2, P0
cmovge P1, P2
cmovg P2, P0
cmovg P0, P1
mov P1, P2
cmp P3, P2
cmovge P2, P3
cmovge P3, P1
cmp S1, P0
mov P3, S1
