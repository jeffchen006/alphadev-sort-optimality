# n=5 model=out iset=I1 prefix14_class=3482
mov S1, P1
cmp P2, S1
mov S2, P0
cmovg P1, P2
cmovge P2, S1
cmovle S1, P2
cmp S2, P3
cmovle P0, P3
cmovle P3, S2
cmp P3, S1
cmovg S1, P3
cmovg P3, P2
cmp P0, P1
cmovg P3, P0
