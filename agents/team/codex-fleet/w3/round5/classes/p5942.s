# n=5 model=out iset=I1 prefix14_class=5942
mov S2, P2
cmp P3, P0
mov S0, P3
cmovle S0, P0
cmovle P0, P3
cmp P1, S2
cmovge S2, P1
cmovle P2, P1
cmp S2, S0
cmovle P1, S0
cmovle S0, S2
cmovle S2, P1
mov S1, P2
cmp P0, P2
