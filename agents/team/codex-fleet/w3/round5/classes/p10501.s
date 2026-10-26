# n=5 model=out iset=I1 prefix14_class=10501
cmp P0, P3
cmovle S2, P0
cmovge S2, P3
cmovle P0, P3
cmp P1, P2
mov S0, P1
mov S1, S2
cmovle P1, P2
cmovge S0, P2
cmp P1, P0
cmovle P2, P1
cmovle P1, P0
cmovle P0, P2
mov P3, P0
