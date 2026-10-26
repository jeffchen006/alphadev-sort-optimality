# n=5 model=out iset=I1 prefix14_class=12759
mov S1, P3
mov S2, P0
cmp P1, S2
cmovg P0, P1
cmovg P1, S2
cmp P2, S1
cmovle P3, P2
cmovg S1, P2
cmp P3, P1
cmovg S2, P1
cmovge P1, P3
cmovg P3, S2
cmp S1, P0
mov P3, P1
