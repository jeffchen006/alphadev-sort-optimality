# n=5 model=out iset=I1 prefix14_class=1623
mov S0, P1
cmp P2, P3
cmovge S1, P2
cmovle S1, P3
cmovge P2, P3
cmp P0, S0
cmovle P1, P0
mov S2, P1
cmovge S0, P0
cmp P2, S2
cmovle S2, P2
cmovle P2, P1
mov P1, S0
cmp S1, S0
