# n=5 model=out iset=I1 prefix14_class=9798
mov S1, P1
cmp P2, P0
mov S2, P2
cmovle S2, P0
cmovge P2, P0
cmp S1, P3
cmovg S1, P3
cmovle P1, P3
cmp S2, P1
cmovg P3, P1
cmovge P1, S2
cmovg S2, P3
mov P1, S1
cmp P2, P1
