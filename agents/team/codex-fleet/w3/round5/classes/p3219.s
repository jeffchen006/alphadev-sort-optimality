# n=5 model=out iset=I1 prefix14_class=3219
mov S1, P3
cmp P0, S1
cmovg S1, P0
mov S2, P2
cmovle P3, P0
cmp P1, S2
cmovle P2, P1
cmovge S2, P1
mov P1, P2
cmp P3, P1
cmovg P2, P3
cmovge P3, P1
mov P3, S2
cmp S1, S2
