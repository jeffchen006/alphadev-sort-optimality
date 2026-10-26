# n=5 model=out iset=I1 prefix14_class=5420
cmp P2, P0
cmovge S1, P0
cmovge P0, P2
cmovg P2, S1
mov S2, P1
cmp P1, P3
cmovle P1, P3
cmovle P3, S2
mov S2, P3
cmp S2, P2
cmovg P3, P2
cmovge P2, S2
cmp P0, P1
mov S2, P1
