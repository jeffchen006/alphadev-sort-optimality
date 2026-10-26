# n=5 model=out iset=I1 prefix14_class=3630
cmp P3, P2
cmovle S1, P3
cmovl P3, P2
cmovle P2, S1
cmp P0, P1
cmovle S2, P1
cmovl P1, P0
cmovl P0, S2
cmp P1, P2
cmovge S1, P2
cmovg P2, P1
cmovle S1, P1
cmp P3, P0
cmovge S1, P3
