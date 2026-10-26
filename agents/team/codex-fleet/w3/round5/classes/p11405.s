# n=5 model=out iset=I1 prefix14_class=11405
cmp P2, P0
cmovg S1, P2
cmovle S1, P0
cmovle P0, P2
mov S2, P1
cmp P1, P3
cmovle P1, P3
cmovg S2, P3
mov P3, S1
cmp P0, S2
cmovge P2, S2
cmovge S2, P0
cmovg P0, P2
cmp S1, P1
