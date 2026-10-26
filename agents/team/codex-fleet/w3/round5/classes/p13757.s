# n=5 model=out iset=I1 prefix14_class=13757
cmp P2, P0
mov S1, P0
cmovge P0, P2
cmovle S1, P2
mov P2, P1
cmp P1, P3
cmovge P2, P3
cmovle P1, P3
cmp P1, P0
mov P3, S1
cmovge S2, P1
cmovg P1, P0
cmovge P0, S2
cmp P3, P2
