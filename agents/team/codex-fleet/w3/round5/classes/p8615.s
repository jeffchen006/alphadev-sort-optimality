# n=5 model=out iset=I1 prefix14_class=8615
mov S0, P1
cmp P0, P2
cmovle S2, P2
cmovle P2, P0
cmovg S2, P0
cmp P1, P3
cmovge P1, P3
cmovge P3, S0
mov S1, P2
cmp P3, S2
cmovge P0, S2
cmovg S2, P3
cmovge P3, P0
cmp P2, P1
