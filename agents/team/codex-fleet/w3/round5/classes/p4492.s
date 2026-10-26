# n=5 model=out iset=I1 prefix14_class=4492
cmp P3, P2
mov S2, P2
cmovge S2, P3
cmovg P3, P2
cmp P0, P1
mov S1, P0
cmovle P0, P1
cmovge S1, P1
cmp S2, P0
cmovg P1, S2
cmovg S2, P0
cmovg P0, P1
cmp P3, S1
cmovge P0, P3
