# n=5 model=out iset=I1 prefix14_class=7286
mov S2, P2
mov S1, P0
cmp P1, S2
cmovg S2, P1
cmovle P2, P1
cmp P3, P0
cmovle S1, P3
cmovle P3, P0
mov P1, S1
cmp S1, P2
cmovg S1, P2
cmovge P2, P1
cmp S2, P3
cmovge P1, P3
