# n=5 model=out iset=I1 prefix14_class=915
cmp P3, P0
cmovg S1, P3
cmovle S1, P0
cmovle P0, P3
mov S2, P2
mov P3, S1
cmp S2, P1
cmovge P2, P1
cmovge P1, S2
cmp P1, S1
cmovge P3, P1
cmovle S1, P1
cmp P2, P0
mov P3, P0
