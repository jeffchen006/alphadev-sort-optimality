# n=5 model=out iset=I1 prefix14_class=4700
mov S2, P3
cmp P2, P3
mov S1, P0
cmovle P3, P2
cmovg S2, P2
cmp S1, P1
cmovle P0, P1
cmovge S1, P1
cmp S2, P0
cmovge P1, P0
cmovge P0, S2
cmovge S2, P1
cmp P3, S1
cmovg P0, S1
