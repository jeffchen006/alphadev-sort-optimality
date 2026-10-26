# n=5 model=out iset=I1 prefix14_class=5059
mov S2, P0
cmp P2, S2
cmovge P0, P2
cmovle S2, P2
mov S0, P3
cmp P1, P3
mov S1, S2
cmovg P3, P1
cmovle S0, P1
cmp S0, S2
cmovle S2, S0
cmovge S1, S0
cmp P3, P0
cmovle P2, P0
