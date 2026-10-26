# n=5 model=out iset=I1 prefix14_class=4068
mov S0, P2
cmp P1, S0
cmovge P2, P1
mov S2, P3
cmovle S0, P1
cmp S2, P0
cmovle P3, P0
cmovle P0, S2
cmp S0, P0
cmovg P1, S0
cmovle P1, P0
cmovge S0, P0
mov P0, P2
cmp P2, P3
