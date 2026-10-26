# n=5 model=out iset=I1 prefix14_class=11502
cmp P3, P0
mov S2, P3
mov S1, P2
cmovle P3, P0
cmovl P0, S2
cmp S1, P1
cmovle S1, P1
cmovge P2, P1
cmp P0, P2
cmovle P1, P0
cmovl P0, P2
cmovle P2, P1
cmp P3, S1
cmovg S2, P3
