# n=5 model=out iset=I1 prefix14_class=913
cmp P3, P0
cmovg S2, P3
cmovle S2, P0
cmovle P0, P3
mov S1, P1
mov P3, S2
cmp S1, P2
cmovge P1, P2
cmovge P2, S1
cmp P2, P3
cmovle P3, P2
cmovge S2, P2
cmp P1, P0
cmovle S2, P0
