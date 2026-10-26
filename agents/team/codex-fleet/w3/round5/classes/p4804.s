# n=5 model=out iset=I1 prefix14_class=4804
mov S2, P2
cmp P1, S2
cmovg P2, P1
cmovle S2, P1
cmp P3, P0
cmovg S1, P3
cmovge P3, P0
cmovg P0, S1
cmp S2, P3
cmovle P1, P3
cmovge P1, S2
cmovle P3, S2
cmp P2, P0
mov P3, P0
