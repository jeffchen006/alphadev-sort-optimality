# n=5 model=out iset=I1 prefix14_class=10123
cmp P2, P1
mov S1, P0
mov S0, P1
cmovle P1, P2
cmovle P2, S0
cmp S1, P3
cmovg S1, P3
cmovle P0, P3
cmp P2, P0
cmovle S0, P2
cmovle P2, P0
cmovge S0, P0
cmp P1, S1
cmovge S2, P1
