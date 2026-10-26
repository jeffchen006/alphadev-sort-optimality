# n=5 model=out iset=I1 prefix14_class=1008
mov S2, P1
cmp S2, P2
cmovle S2, P2
cmovle P2, P1
cmp P3, P0
cmovg S1, P3
mov P1, S2
cmovge P3, P0
mov S0, P3
cmovg P0, S1
cmp P0, S2
cmovge P1, P0
cmovg P0, S2
cmp P2, P3
