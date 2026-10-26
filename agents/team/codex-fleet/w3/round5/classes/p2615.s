# n=5 model=out iset=I1 prefix14_class=2615
mov S2, P1
cmp P0, S2
cmovge S2, P0
mov S1, S2
cmovge P0, P1
mov P1, P3
cmp P2, P3
cmovg P3, P2
cmovle P1, P2
cmp P3, S1
cmovle S1, P3
cmovle P3, S2
mov P3, P0
cmp P1, P3
