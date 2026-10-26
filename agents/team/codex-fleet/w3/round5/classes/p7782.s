# n=5 model=out iset=I1 prefix14_class=7782
mov S1, P3
mov S2, P0
cmp P3, P1
cmovle S1, P1
cmovg P3, P1
cmp P0, P2
cmovle P0, P2
cmovge S2, P2
mov P1, S1
cmp P3, S2
cmovge P2, S2
cmovg S2, P3
cmovge P3, P2
cmp S1, P0
