# n=5 model=out iset=I1 prefix14_class=5048
mov S2, P1
mov S0, P0
cmp P3, S2
cmovge S2, P3
cmovle P1, P3
cmp P2, P0
cmovle S0, P2
cmovge P0, P2
cmp S0, P1
mov P2, P1
cmovle P2, S0
cmovg P1, S0
cmp P0, S2
cmovle S1, S2
