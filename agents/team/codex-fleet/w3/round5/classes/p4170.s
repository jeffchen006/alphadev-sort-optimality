# n=5 model=out iset=I1 prefix14_class=4170
cmp P0, P1
mov S1, P1
cmovge P1, P0
cmovle S1, P0
mov S2, P2
cmp S2, P3
cmovle P2, P3
mov S0, S1
cmovle P3, S2
cmp P3, S0
cmovle S1, P3
cmovge S0, P3
mov P3, P1
mov S1, S0
