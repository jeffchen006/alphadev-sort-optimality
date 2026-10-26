# n=5 model=out iset=I1 prefix14_class=512
cmp P3, P0
mov S2, P0
cmovge P0, P3
cmovle S2, P3
mov S0, P2
cmp P2, P1
cmovge P2, P1
cmovge P1, S0
mov P3, S2
cmp P2, P3
cmovle S2, P2
cmovle P2, P3
cmp P0, P1
cmovge S0, P0
