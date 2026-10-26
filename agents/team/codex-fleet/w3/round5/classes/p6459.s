# n=5 model=out iset=I1 prefix14_class=6459
mov S2, P3
cmp P3, P1
cmovle P3, P1
cmovle P1, S2
cmp P2, P0
cmovg S2, P0
cmovle S2, P2
cmovle P2, P0
mov P0, P2
cmp P2, P3
cmovge P0, P3
cmovg P3, P2
cmp S2, P1
mov P3, P1
