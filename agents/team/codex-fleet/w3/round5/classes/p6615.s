# n=5 model=out iset=I1 prefix14_class=6615
cmp P2, P1
cmovge S1, P2
cmovle S1, P1
cmovg P2, P1
cmp P0, P3
cmovle P1, P3
cmovle P3, P0
cmovg P1, P0
cmp P1, S1
cmovle S2, S1
cmovge S2, P1
cmovg P1, S1
cmp P3, P2
cmovge S1, P2
