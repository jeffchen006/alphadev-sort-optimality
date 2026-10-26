# n=5 model=out iset=I1 prefix14_class=6033
cmp P2, P3
cmovle S2, P3
cmovle P3, P2
cmovge S2, P2
cmovl P2, S2
cmp P1, P0
cmovle S1, P0
cmovle P0, P1
cmovl P1, S1
cmp P1, P2
cmovle S2, P1
cmovg P2, P1
cmp P3, P0
cmovl S1, P3
