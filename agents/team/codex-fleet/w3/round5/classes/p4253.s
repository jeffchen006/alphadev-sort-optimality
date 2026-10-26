# n=5 model=out iset=I1 prefix14_class=4253
cmp P3, P0
cmovle S1, P0
cmovg S1, P3
cmovle P0, P3
mov S2, P1
cmp P2, P1
cmovg P1, P2
cmovg P2, S2
mov P3, P2
cmp P0, P3
cmovle P2, P0
cmovge P3, P0
cmp P1, S1
cmovg P2, P1
