# n=5 model=out iset=I1 prefix14_class=2255
cmp P3, P0
mov S2, P0
cmovge S2, P3
cmovge P3, P0
cmp P1, P2
cmovge S0, P2
cmovge P2, P1
cmovge P1, S0
mov S1, P2
cmp S1, S2
cmovle S1, S2
mov S1, P3
cmovle S2, P2
cmp P3, P1
