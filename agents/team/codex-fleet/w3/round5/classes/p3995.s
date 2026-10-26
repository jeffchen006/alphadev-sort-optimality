# n=5 model=out iset=I1 prefix14_class=3995
mov S1, P1
cmp S1, P0
cmovle P1, P0
mov S2, P3
cmovg S1, P0
cmp S2, P2
cmovge S2, P2
cmovg P2, P3
mov P0, S1
cmp P0, S2
cmovge P0, S2
cmovge S2, S1
cmp P1, P2
cmovle S1, S2
