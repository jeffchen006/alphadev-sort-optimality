# n=5 model=out iset=I1 prefix14_class=2000
mov S1, P3
mov S0, P1
cmp S1, P0
cmovge P3, P0
cmovle S1, P0
cmp P2, P1
cmovge S0, P2
cmovle P1, P2
cmp S1, S0
cmovle P2, S0
cmovge P2, S1
cmovle S0, S1
cmp P1, P3
cmovle P2, P1
