# n=5 model=out iset=I1 prefix14_class=8430
cmp P0, P2
cmovge S1, P0
mov S2, P1
cmovg P0, P2
cmovg P2, S1
cmp P1, P3
cmovge P1, P3
cmovge P3, S2
mov S2, P2
cmp P3, P2
cmovge P2, P3
cmovge P3, S2
cmp P0, P1
cmovle S2, P1
