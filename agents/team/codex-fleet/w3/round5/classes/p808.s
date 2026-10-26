# n=5 model=out iset=I1 prefix14_class=808
mov S2, P3
mov S1, P0
cmp S1, P2
cmovg S1, P2
cmovg P2, P0
cmovle P0, P2
cmp S2, P1
cmovg S2, P1
cmovge P1, P3
cmp P1, P0
cmovle P2, P1
cmovg P0, P1
mov P3, S2
cmp S2, S1
