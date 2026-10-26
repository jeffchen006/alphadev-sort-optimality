# n=5 model=out iset=I1 prefix14_class=10500
cmp P0, P3
cmovle S2, P0
cmovge S2, P3
cmovle P0, P3
cmp P1, P2
mov S1, P1
mov S0, S2
cmovle P1, P2
cmovg S1, P2
cmp P1, P0
cmovle P2, P1
cmovle P1, P0
cmovle P0, P2
cmp S2, S1
