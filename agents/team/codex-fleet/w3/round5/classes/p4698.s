# n=5 model=out iset=I1 prefix14_class=4698
mov S1, P0
mov S2, P3
cmp P2, P3
cmovle P3, P2
cmovg S2, P2
cmp S1, P1
cmovg S1, P1
cmovle P0, P1
cmp P0, S2
cmovge P1, S2
cmovg S2, P0
cmovg P0, P1
cmp P3, S1
cmovle S2, P3
