# n=5 model=out iset=I1 prefix14_class=8006
mov S1, P0
cmp P2, S1
cmovge P0, P2
cmovge P2, S1
cmp P3, P1
cmovle S1, P1
mov S0, P0
cmovle P1, P3
mov S2, P2
cmovle P3, S1
cmp P1, S2
cmovle P2, P1
cmovge S2, P1
cmp S0, P3
