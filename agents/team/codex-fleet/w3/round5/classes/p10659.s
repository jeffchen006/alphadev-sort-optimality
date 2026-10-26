# n=5 model=out iset=I1 prefix14_class=10659
cmp P1, P0
mov S0, P3
cmovle S1, P0
cmovle P0, P1
cmovle P1, S1
mov S2, P1
cmp P3, P2
cmovge S0, P2
cmovg P2, P3
cmp S2, P2
cmovge P1, P2
cmovge P2, S2
cmp S0, P0
cmovge P3, S0
