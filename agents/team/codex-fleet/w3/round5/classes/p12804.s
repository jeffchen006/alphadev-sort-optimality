# n=5 model=out iset=I1 prefix14_class=12804
mov S1, P2
mov S2, P0
cmp P3, P2
cmovle P2, P3
cmovg S1, P3
cmp P0, P1
cmovg S2, P1
cmovge P1, P0
cmp S2, P2
cmovge P3, S2
cmovg S2, P2
cmovg P2, P3
cmp P1, S1
cmovle S2, P1
