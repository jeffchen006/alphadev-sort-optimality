# n=5 model=out iset=I1 prefix14_class=6419
mov S1, P2
cmp S1, P3
cmovg P2, P3
cmovg P3, S1
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmovle P0, S1
mov S1, P0
cmp P3, S1
cmovle S1, P3
cmovge P0, P3
cmp P2, P1
cmovge P0, P1
