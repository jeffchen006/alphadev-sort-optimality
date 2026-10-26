# n=5 model=out iset=I1 prefix14_class=14496
mov S0, P3
cmp S0, P1
cmovge S0, P1
cmovge P1, P3
cmp P2, P0
mov S2, P0
cmovle P0, P2
cmovle P2, S2
cmp S0, P0
mov P3, P1
cmovle S1, S0
cmovle S0, P0
mov S2, S0
cmovle P0, S1
