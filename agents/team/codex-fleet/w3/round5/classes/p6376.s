# n=5 model=out iset=I1 prefix14_class=6376
cmp P0, P3
mov S1, P3
cmovle P3, P0
cmovg S1, P0
mov S2, P2
cmp P1, S2
cmovge S2, P1
cmovle P2, P1
mov S0, S1
cmp S2, S0
cmovle S1, S2
cmovge S0, S2
cmp P2, P3
cmovge S2, P2
