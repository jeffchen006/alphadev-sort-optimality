# n=5 model=out iset=I1 prefix14_class=5510
mov S1, P2
cmp P2, P0
cmovle S1, P0
cmovge P2, P0
cmp P1, P3
mov P0, P2
cmovle S2, P1
cmovle P1, P3
cmovle P3, S2
cmp P2, P3
cmovg P2, P3
cmovl P0, P3
cmp S1, P1
cmovle S2, P1
