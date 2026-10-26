# n=5 model=out iset=I1 prefix14_class=7160
cmp P1, P0
mov S0, P3
cmovge S2, P1
cmovge P1, P0
cmovle S2, P0
mov P0, P1
cmp P2, S0
cmovle P3, P2
cmovle P2, S0
cmp P1, P3
cmovle P1, P3
cmovge P0, P3
cmp P2, S2
cmovge P3, S2
