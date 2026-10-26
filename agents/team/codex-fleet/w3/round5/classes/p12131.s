# n=5 model=out iset=I1 prefix14_class=12131
cmp P3, P1
mov S1, P1
cmovg P1, P3
cmovle S1, P3
mov S2, P2
cmp P0, P2
mov P3, P1
cmovle S2, P0
cmovge P2, P0
cmp S2, S1
cmovg P0, S1
cmovge S1, S2
cmovg S2, P0
cmp P1, P2
