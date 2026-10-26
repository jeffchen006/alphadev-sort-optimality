# n=5 model=out iset=I1 prefix14_class=839
cmp P2, P1
cmovle S2, P1
mov S1, P3
cmovg S2, P2
cmovge P2, P1
cmp S1, P0
cmovg S1, P0
cmovg P0, P3
cmp P0, S2
cmovge P1, S2
cmovg S2, P0
cmovg P0, P1
cmp P2, S1
mov P1, P2
