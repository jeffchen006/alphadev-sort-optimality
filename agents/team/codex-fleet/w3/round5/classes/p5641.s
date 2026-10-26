# n=5 model=out iset=I1 prefix14_class=5641
mov S2, P1
mov S1, P0
cmp P1, P3
cmovle S2, P3
cmovg P1, P3
cmp P2, S1
cmovge P0, P2
cmovle S1, P2
cmp S1, P1
cmovge P3, P1
cmovg P1, S1
mov P2, S2
cmovge S1, P3
cmp P2, P0
