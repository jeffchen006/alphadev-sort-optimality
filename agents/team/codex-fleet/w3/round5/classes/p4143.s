# n=5 model=out iset=I1 prefix14_class=4143
mov S1, P3
mov S2, P2
cmp P0, S2
cmovge P2, P0
cmovle S2, P0
cmp P1, S1
cmovg S1, P1
cmovle P3, P1
cmp S2, P3
mov P0, P3
cmovg P0, S2
cmovg S2, P3
cmp S1, P2
cmovg P3, S1
