# n=5 model=out iset=I1 prefix14_class=5299
cmp P2, P0
mov S2, P2
cmovge P2, P0
cmovge P0, S2
mov S1, P1
cmp S1, P3
cmovge P1, P3
mov S2, P1
cmovle S1, P3
cmp P1, P2
cmovle S2, P2
cmovle P2, P1
cmp S1, P0
cmovg P1, S1
