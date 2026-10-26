# n=5 model=out iset=I1 prefix14_class=6892
mov S0, P2
mov S2, P1
cmp P0, P2
cmovle P2, P0
cmovle P0, S0
cmp S2, P3
cmovle S2, P3
mov S1, P0
cmovge P1, P3
cmp S2, S1
cmovle P0, S2
cmovge S1, S2
cmp P1, P2
cmovg S2, P2
