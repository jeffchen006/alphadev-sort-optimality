# n=5 model=out iset=I1 prefix14_class=2206
cmp P3, P1
cmovge S1, P1
cmovg P1, P3
cmovge P3, S1
cmp P2, P0
mov S2, P0
mov S0, P1
cmovge S2, P2
cmovge P2, P0
cmp P1, S2
mov P0, P2
cmovle S0, S2
cmovle S2, P1
cmp P3, P2
