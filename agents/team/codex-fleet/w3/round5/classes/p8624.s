# n=5 model=out iset=I1 prefix14_class=8624
mov S2, P1
cmp P3, P1
cmovg P1, P3
cmovle S2, P3
cmp P0, P2
cmovge P3, P0
cmovg P0, P2
mov S1, S2
cmovge P2, P3
cmp P2, P1
cmovge P3, P1
cmovge P1, P2
cmovge P2, P3
cmp S2, P0
