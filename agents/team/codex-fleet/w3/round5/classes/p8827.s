# n=5 model=out iset=I1 prefix14_class=8827
cmp P1, P0
cmovle S2, P0
mov S1, P2
cmovge S2, P1
cmovge P1, P0
cmp P3, S1
cmovle S1, P3
cmovg P2, P3
mov P3, P2
cmp P3, S2
cmovg P2, S2
cmovle P3, S2
cmp P1, S1
cmovg P3, P1
