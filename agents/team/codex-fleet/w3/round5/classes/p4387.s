# n=5 model=out iset=I1 prefix14_class=4387
cmp P3, P1
cmovge S1, P1
cmovg P1, P3
mov S2, P2
cmovg P3, S1
cmp P0, P2
cmovle P2, P0
cmovge S2, P0
cmp S2, P1
cmovg S0, S2
cmovg S2, P1
cmovle S0, P1
mov P1, P3
cmp P3, P2
