# n=5 model=out iset=I1 prefix14_class=2877
mov S2, P2
cmp S2, P1
cmovle S2, P1
cmovl P1, P2
mov P2, P0
cmp P2, P3
cmovge P0, P3
cmovle P2, P3
cmp P2, S2
cmovl P3, S2
cmovl S2, P2
cmovl P2, P3
cmp P1, P0
cmovle S1, P1
