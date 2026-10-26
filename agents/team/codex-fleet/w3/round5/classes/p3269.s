# n=5 model=out iset=I1 prefix14_class=3269
cmp P0, P1
mov S2, P2
cmovge S0, P0
cmovg P0, P1
cmovg P1, S0
cmp P3, S2
mov S1, P0
cmovge S2, P3
cmovge P3, P2
cmp P0, P3
mov P2, P1
cmovle S1, P3
cmovge P0, P3
cmp P2, S2
