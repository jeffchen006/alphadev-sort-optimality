# n=5 model=out iset=I1 prefix14_class=10560
mov S1, P3
cmp P0, S1
cmovg P3, P0
mov S2, P2
cmovle S1, P0
cmp P1, S2
cmovle S2, P1
cmovge P2, P1
cmp P3, P2
cmovle P0, P3
cmovl P3, P2
cmovle P2, P0
cmp S2, S1
cmovle P1, S1
