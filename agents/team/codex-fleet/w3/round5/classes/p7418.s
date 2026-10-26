# n=5 model=out iset=I1 prefix14_class=7418
cmp P1, P3
mov S2, P0
mov S1, P3
cmovge S1, P1
cmovg P1, P3
cmp P2, P0
cmovg P0, P2
cmovge P2, S2
cmp P1, P2
cmovge S2, P1
cmovg P1, P2
cmovge P2, S2
cmp P0, S1
cmovle P1, S1
