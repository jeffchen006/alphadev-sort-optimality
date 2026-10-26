# n=5 model=out iset=I1 prefix14_class=6734
mov S1, P0
cmp P1, P0
cmovge P0, P1
cmovge P1, S1
mov S1, P3
cmp P3, P2
cmovle S1, P2
cmovge P3, P2
cmp P0, S1
cmovge P2, P0
cmovge P0, S1
cmovge S1, P2
cmp P3, P1
mov S2, P3
