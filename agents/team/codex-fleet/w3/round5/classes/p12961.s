# n=5 model=out iset=I1 prefix14_class=12961
mov S0, P1
mov S2, P2
cmp P0, S2
cmovge S2, P0
cmovle P2, P0
mov S1, P2
cmp P3, P1
cmovge S0, P3
cmovge P3, P1
cmp S1, P3
cmovle S1, P3
cmovge P2, P3
cmp S0, S2
cmovge P2, S0
