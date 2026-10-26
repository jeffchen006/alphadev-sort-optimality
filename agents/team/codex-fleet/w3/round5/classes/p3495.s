# n=5 model=out iset=I1 prefix14_class=3495
cmp P3, P0
cmovle S2, P3
cmovg S2, P0
cmovle P3, P0
cmp P1, P2
mov P0, P1
cmovle P1, P2
cmovg P0, P2
mov S0, P0
cmp S2, S0
cmovge S0, S2
cmovge S2, P0
cmp P1, P3
cmovle S1, P1
