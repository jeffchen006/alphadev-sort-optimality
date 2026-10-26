# n=5 model=out iset=I1 prefix14_class=1880
mov S0, P2
cmp P1, S0
cmovle P2, P1
cmovle P1, S0
cmp P3, P0
mov S1, P0
cmovge S1, P3
cmovle P0, P3
mov S2, P1
cmp S1, P1
cmovle S2, S1
cmovle S1, P1
mov S1, P0
cmp P2, S1
