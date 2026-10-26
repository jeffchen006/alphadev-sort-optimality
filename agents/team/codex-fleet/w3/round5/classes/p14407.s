# n=5 model=out iset=I1 prefix14_class=14407
cmp P0, P3
mov S2, P2
cmovge S1, P3
cmovle S1, P0
cmovg P3, P0
cmp P1, S2
cmovg S2, P1
cmovg P1, P2
cmp S1, P1
cmovg P2, S1
cmovge S1, P1
cmovg P1, P2
cmp P3, S2
cmovge P2, P3
