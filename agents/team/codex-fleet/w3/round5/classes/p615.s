# n=5 model=out iset=I1 prefix14_class=615
mov S0, P0
cmp P3, P1
cmovle S2, P1
cmovg S2, P3
cmovg P3, P1
cmp P0, P2
cmovge S0, P2
cmovg P2, P0
mov P0, S2
cmp P2, P0
cmovg S2, P2
cmovle P0, P2
cmp P3, S0
cmovge P1, S0
