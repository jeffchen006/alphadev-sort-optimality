# n=5 model=out iset=I1 prefix14_class=14294
cmp P3, P0
cmovge S0, P0
cmovg P0, P3
cmovg P3, S0
mov S1, P1
cmp S1, P2
cmovle S1, P2
cmovg P1, P2
mov S2, P3
cmp P1, S2
cmovge S2, P1
cmovle P3, P1
cmp S1, P0
mov P1, P0
