# n=5 model=out iset=I1 prefix14_class=5107
cmp P1, P0
mov S2, P2
mov S1, P1
cmovg P1, P0
cmovle S1, P0
mov S0, P1
cmp S2, P3
cmovge P2, P3
cmovle S2, P3
cmp P2, S0
cmovg P1, P2
cmovle S0, P2
cmp S2, S1
cmovge P3, S1
