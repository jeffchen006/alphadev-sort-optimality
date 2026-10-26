# n=5 model=out iset=I1 prefix14_class=7063
mov S2, P2
cmp P3, P2
cmovg S2, P3
cmovg P3, P2
cmp P0, P1
cmovge P2, P0
cmovge P0, P1
cmovge P1, P2
mov S1, P3
cmp S1, P0
cmovle S1, P0
cmovle P0, P3
cmp S2, P1
mov P3, S2
