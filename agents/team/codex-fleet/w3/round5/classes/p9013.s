# n=5 model=out iset=I1 prefix14_class=9013
cmp P1, P0
mov S0, P1
cmovge P1, P0
mov S2, P3
cmovle S0, P0
cmp P2, S2
cmovle P3, P2
cmovle P2, S2
cmp S0, P2
cmovge P0, P2
cmovg P2, S0
cmovge S0, P0
cmp P3, P1
cmovle S1, P1
