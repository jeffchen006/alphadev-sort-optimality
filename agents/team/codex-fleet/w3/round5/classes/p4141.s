# n=5 model=out iset=I1 prefix14_class=4141
mov S1, P0
mov S2, P2
cmp P3, S2
cmovge P2, P3
cmovle S2, P3
cmp P1, P0
cmovge P0, P1
cmovle S1, P1
mov P3, S1
cmp S2, S1
cmovg P3, S2
cmovg S2, S1
cmp P0, P2
cmovle S1, P2
