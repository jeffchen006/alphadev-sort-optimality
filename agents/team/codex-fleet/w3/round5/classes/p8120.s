# n=5 model=out iset=I1 prefix14_class=8120
mov S1, P3
cmp P0, S1
cmovle S1, P0
cmovle P0, P3
cmp P2, P1
mov P3, S1
cmovle S2, P1
cmovle P1, P2
cmovl P2, S2
cmp P3, P1
cmovge S1, P1
cmovl P3, P1
cmp P0, P2
cmovge P1, P0
