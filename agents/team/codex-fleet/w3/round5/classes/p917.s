# n=5 model=out iset=I1 prefix14_class=917
cmp P3, P2
mov S2, P3
cmovle S2, P2
cmovle P2, P3
cmp P1, P0
cmovge S0, P0
cmovle S0, P1
cmovge P0, P1
mov P3, S2
cmp P0, S2
cmovle S2, P0
cmovge P3, P0
mov S1, P2
mov P0, S2
