# n=5 model=out iset=I1 prefix14_class=10336
mov S1, P3
cmp P0, S1
cmovge P3, P0
cmovle S1, P0
mov S0, P2
cmp P2, P1
cmovle P2, P1
cmovle P1, S0
mov S2, P3
cmp S2, P2
cmovge S2, P2
cmovg P2, P3
cmp S1, P1
cmovge S0, S1
