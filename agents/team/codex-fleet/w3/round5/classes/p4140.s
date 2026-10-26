# n=5 model=out iset=I1 prefix14_class=4140
mov S1, P0
mov S2, P2
cmp P1, P2
cmovge P2, P1
cmovle S2, P1
cmp P3, P0
cmovge P0, P3
cmovle S1, P3
mov P1, S1
cmp S2, S1
cmovg P1, S2
cmovg S2, S1
cmp P0, P2
cmovle S1, P2
