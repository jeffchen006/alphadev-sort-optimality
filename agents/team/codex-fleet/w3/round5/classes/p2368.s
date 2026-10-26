# n=5 model=out iset=I1 prefix14_class=2368
mov S0, P1
cmp P2, P0
cmovge S1, P2
cmovle S1, P0
cmovge P2, P0
cmp P3, P1
cmovle S0, P3
cmovle P3, P1
cmp S1, P3
cmovge P1, P3
cmovge P3, S1
cmovle P1, S1
cmp P2, S0
cmovle S1, S0
