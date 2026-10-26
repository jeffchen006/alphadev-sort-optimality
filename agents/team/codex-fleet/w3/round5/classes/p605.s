# n=5 model=out iset=I1 prefix14_class=605
mov S2, P3
mov S1, P0
cmp S2, P1
cmovle S2, P1
cmovge P3, P1
cmp P0, P2
cmovge P0, P2
cmovg P2, S1
cmp P2, S2
cmovge P1, S2
cmovle P1, P2
cmovge S2, P2
cmp P3, P0
cmovle S0, P0
