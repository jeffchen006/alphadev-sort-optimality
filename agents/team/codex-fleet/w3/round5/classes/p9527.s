# n=5 model=out iset=I1 prefix14_class=9527
cmp P2, P0
cmovle S1, P0
cmovle P0, P2
cmovle P2, S1
cmp P3, P1
mov S0, P3
mov S2, P0
cmovge P3, P1
cmovle S0, P1
mov P1, S0
cmp P0, P3
cmovle P0, P3
cmovge S2, P3
cmovge P3, P0
