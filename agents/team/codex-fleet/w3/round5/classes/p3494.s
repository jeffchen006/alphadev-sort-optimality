# n=5 model=out iset=I1 prefix14_class=3494
cmp P3, P1
cmovle S2, P3
cmovg S2, P1
cmovle P3, P1
cmp P0, P2
mov P1, P0
cmovle P0, P2
cmovg P1, P2
mov S0, P1
cmp S2, S0
cmovge S0, S2
cmovge S2, P1
cmp P0, P3
cmovle S1, P0
