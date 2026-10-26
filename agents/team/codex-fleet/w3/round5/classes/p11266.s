# n=5 model=out iset=I1 prefix14_class=11266
mov S2, P1
cmp S2, P2
cmovle S2, P2
cmovge P1, P2
cmp P3, P0
cmovg S1, P0
cmovge P0, P3
cmovg P3, S1
cmp S2, P0
cmovle P2, P0
cmovg P2, S2
cmovg S2, P0
mov P0, P1
cmp P1, P3
