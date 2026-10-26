# n=5 model=out iset=I1 prefix14_class=6643
mov S1, P1
cmp P1, P2
cmovge S1, P2
cmovle P1, P2
cmp P0, P3
cmovge P2, P0
cmovge P0, P3
cmovg P3, P2
cmovle P2, P3
cmp P2, P1
cmovge P2, P1
cmovle P3, P1
cmp P0, S1
cmovle S2, S1
