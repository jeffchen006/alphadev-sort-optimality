# n=5 model=out iset=I1 prefix14_class=3201
mov S2, P3
cmp P0, S2
cmovle P3, P0
cmovg S2, P0
cmp P1, P2
cmovge S1, P2
cmovg P2, P1
cmovle S1, P1
cmp S1, P3
mov P1, P3
cmovg P1, S1
cmovg S1, P3
cmp P2, S2
cmovg S0, P2
