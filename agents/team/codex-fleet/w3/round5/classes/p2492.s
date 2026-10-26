# n=5 model=out iset=I1 prefix14_class=2492
cmp P2, P1
cmovg S1, P1
cmovle S1, P2
cmovle P2, P1
cmp P0, P3
cmovg S0, P3
mov S2, P2
mov P1, S1
cmovge P3, P0
cmovg P0, S0
cmp S2, P3
cmovle P2, P3
cmovle P3, S2
cmp S1, P0
