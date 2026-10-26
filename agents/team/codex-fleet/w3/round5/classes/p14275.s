# n=5 model=out iset=I1 prefix14_class=14275
cmp P1, P2
cmovle S1, P2
cmovle P2, P1
cmovl P1, S1
mov S2, P3
cmp P0, S2
cmovge S2, P0
cmovle P3, P0
cmovl P0, S2
cmp P0, P1
cmovle P0, P1
cmovl P1, S2
cmp P3, P2
mov S2, P2
