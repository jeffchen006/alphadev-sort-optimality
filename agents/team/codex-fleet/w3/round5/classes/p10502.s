# n=5 model=out iset=I1 prefix14_class=10502
cmp P0, P3
cmovle S2, P0
cmovge S2, P3
cmovle P0, P3
cmp P1, P2
mov S0, P1
mov S1, S2
cmovle S0, P2
cmovge P1, P2
cmp S0, P0
cmovle P3, S0
cmovle S0, P0
cmovle P0, P3
mov P2, P0
