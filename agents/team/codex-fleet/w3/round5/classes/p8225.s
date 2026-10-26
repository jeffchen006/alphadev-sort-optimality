# n=5 model=out iset=I1 prefix14_class=8225
cmp P0, P1
mov S1, P2
cmovle S2, P0
cmovle P0, P1
cmovge S2, P1
mov S0, S2
cmp P3, P2
cmovge P2, P3
cmovge P3, S1
cmp S0, P3
cmovle S2, P3
cmovge S0, P3
mov S0, S2
mov P3, P2
