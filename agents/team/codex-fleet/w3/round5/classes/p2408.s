# n=5 model=out iset=I1 prefix14_class=2408
cmp P2, P0
mov S1, P0
cmovge S1, P2
mov S2, P3
cmovge P2, P0
cmp P1, S2
cmovg S2, P1
cmovle P3, P1
cmp S2, S1
cmovge P1, S2
cmovge S2, S1
cmovle P1, S1
cmp P3, P2
cmovle P0, P2
