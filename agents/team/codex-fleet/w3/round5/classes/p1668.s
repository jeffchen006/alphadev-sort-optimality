# n=5 model=out iset=I1 prefix14_class=1668
cmp P3, P2
cmovge S1, P2
cmovge P2, P3
cmovle S1, P3
cmp P0, P1
mov P3, P2
cmovg S0, P0
cmovge P0, P1
cmovg P1, S0
cmp P0, S1
mov S2, S1
cmovg S2, P0
cmovle S1, P0
cmp P2, P1
