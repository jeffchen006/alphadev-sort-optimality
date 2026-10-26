# n=5 model=out iset=I1 prefix14_class=8879
mov S2, P2
cmp P0, P1
cmovge S1, P1
cmovge P1, P0
cmovge P0, S1
cmp P2, P3
cmovge S2, P3
cmovle P2, P3
mov P3, P2
cmp P1, P3
cmovg P3, P1
cmovge P1, P2
cmp S2, P0
cmovle S0, S2
