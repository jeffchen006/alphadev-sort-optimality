# n=5 model=out iset=I1 prefix14_class=11655
cmp P1, P3
cmovle S2, P3
cmovl P3, P1
cmovl P1, S2
mov S1, P0
cmp P2, S1
cmovle S1, P2
cmovl P2, P0
mov P0, P1
cmp P2, P0
cmovle P1, P2
cmovge P0, P2
cmp S1, P3
cmovl P0, S1
