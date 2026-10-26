# n=5 model=out iset=I1 prefix14_class=11615
cmp P3, P2
cmovg S0, P3
mov S1, P0
cmovge P3, P2
cmovg P2, S0
cmp P1, P0
mov S2, P3
cmovge S1, P1
cmovge P1, P0
cmp P2, S1
cmovg S0, S1
cmovge S1, P2
cmovg P2, S0
cmp P1, S2
