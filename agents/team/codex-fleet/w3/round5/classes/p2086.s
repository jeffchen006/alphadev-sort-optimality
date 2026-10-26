# n=5 model=out iset=I1 prefix14_class=2086
mov S2, P3
cmp P1, S2
cmovge P3, P1
cmovle S2, P1
mov P1, P2
cmp P1, P0
cmovg P2, P0
cmovge P0, P1
mov P1, P0
cmp P0, P3
cmovle P0, P3
mov P0, P2
cmovge P1, P3
cmp S2, P2
