# n=5 model=out iset=I1 prefix14_class=4701
mov S2, P3
cmp P2, P3
mov S1, P1
cmovle P3, P2
cmovge S2, P2
cmp S1, P0
cmovle P1, P0
cmovge S1, P0
cmp S2, P1
cmovge P0, P1
cmovge P1, S2
cmovge S2, P0
cmp P3, S1
cmovg P1, S1
