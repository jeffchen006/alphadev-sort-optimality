# n=5 model=out iset=I1 prefix14_class=13571
cmp P2, P0
mov S1, P2
cmovle S1, P0
cmovl P0, P2
mov P2, P3
cmp P1, P3
cmovle P2, P1
cmovle P1, P3
cmovle P3, P2
cmp P0, P2
cmovge P3, P0
cmovge P0, P2
cmp P1, S1
cmovle P2, P3
