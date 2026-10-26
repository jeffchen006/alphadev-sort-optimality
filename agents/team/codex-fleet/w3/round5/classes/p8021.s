# n=5 model=out iset=I1 prefix14_class=8021
mov S2, P3
cmp S2, P0
mov S0, P1
cmovle P3, P0
cmovge S2, P0
cmp P1, P2
cmovge P1, P2
cmovle S0, P2
mov S1, P1
cmp P1, S2
cmovle S1, S2
cmovle S2, P1
cmp S0, P3
cmovle P1, S0
