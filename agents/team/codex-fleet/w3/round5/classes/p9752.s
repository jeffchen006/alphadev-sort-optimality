# n=5 model=out iset=I1 prefix14_class=9752
mov S1, P0
cmp S1, P3
cmovg S1, P3
mov S2, S1
cmovge P3, P0
cmp P1, P2
cmovle P0, P2
cmovle P2, P1
cmovle P1, P0
cmp P1, P3
cmovle S0, P1
cmovg S0, P3
cmovg P3, P1
cmp S2, P2
