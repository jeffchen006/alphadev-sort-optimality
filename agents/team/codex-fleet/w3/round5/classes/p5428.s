# n=5 model=out iset=I1 prefix14_class=5428
cmp P3, P0
cmovge S0, P0
cmovge P0, P3
cmovge P3, S0
cmp P1, P2
mov S2, P1
cmovle S2, P2
cmovge P1, P2
mov S1, P1
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
cmp P0, S2
mov P1, P0
