# n=5 model=out iset=I1 prefix14_class=4554
mov S1, P0
cmp P0, P2
mov S2, P3
cmovle S1, P2
cmovg P0, P2
cmp P3, P1
cmovle P3, P1
mov P2, S1
cmovg S2, P1
cmp P3, P2
cmovge P2, P3
cmovg P3, S2
cmovle S1, P3
cmp P0, S2
