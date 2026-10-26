# n=5 model=out iset=I1 prefix14_class=2240
mov S0, P1
cmp P3, P1
cmovg P1, P3
cmovge P3, S0
mov S0, P2
cmp P0, P2
cmovge S0, P0
mov S1, S0
cmovge P0, P2
cmp S1, P1
cmovle S0, P1
cmovle P1, S1
cmp P0, P3
cmovle S2, P0
