# n=5 model=out iset=I1 prefix14_class=9541
cmp P2, P3
cmovge S2, P3
mov S0, P0
cmovg P3, P2
cmovge P2, S2
cmp S0, P1
cmovge P0, P1
cmovle S0, P1
cmp P0, P2
cmovle S1, P0
cmovle P0, P2
cmovle P2, S1
cmp P3, S0
mov P1, S0
