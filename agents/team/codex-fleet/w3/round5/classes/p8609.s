# n=5 model=out iset=I1 prefix14_class=8609
cmp P3, P0
mov S2, P1
cmovle S1, P0
cmovle P0, P3
cmovge S1, P3
cmp P2, S2
cmovle S2, P2
cmovg P1, P2
cmp P1, S1
cmovg P2, P1
cmovge P1, S1
mov P3, S2
cmovg S1, P2
cmp P3, P0
