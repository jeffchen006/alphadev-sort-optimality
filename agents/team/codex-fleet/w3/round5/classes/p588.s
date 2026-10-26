# n=5 model=out iset=I1 prefix14_class=588
mov S2, P2
cmp P1, P0
mov S0, P0
cmovle S0, P1
cmovle P1, P0
mov P0, P1
cmp P2, P3
cmovge S2, P3
mov S1, S2
cmovge P3, P2
cmp P3, P1
cmovge P0, P3
cmovle P1, P3
cmp S0, S1
