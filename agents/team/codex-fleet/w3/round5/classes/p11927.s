# n=5 model=out iset=I1 prefix14_class=11927
mov S2, P2
cmp P3, S2
cmovle P2, P3
mov S1, P1
cmovg S2, P3
cmp P1, P0
cmovg P1, P0
cmovle S1, P0
cmp S2, S1
cmovge P3, S1
cmovg S1, S2
cmovg S2, P3
cmp P2, P1
cmovge P3, P1
