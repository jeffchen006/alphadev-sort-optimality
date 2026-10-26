# n=5 model=out iset=I1 prefix14_class=11181
cmp P3, P1
mov S1, P2
cmovge S2, P1
cmovg P1, P3
cmovge P3, S2
cmp S1, P0
cmovle S1, P0
mov S0, P3
cmovle P0, P2
cmp P1, S1
cmovg S2, P1
cmovg P1, S1
cmovg S1, S2
cmp P3, P0
