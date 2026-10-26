# n=5 model=out iset=I1 prefix14_class=7067
mov S2, P0
cmp P3, P0
cmovge S2, P3
cmovg P3, P0
cmp P1, P2
cmovge P0, P1
mov S1, P3
cmovge P1, P2
cmovg P2, P0
cmp S1, P1
cmovle S1, P1
cmovle P1, P3
cmp S2, P2
mov P3, S2
