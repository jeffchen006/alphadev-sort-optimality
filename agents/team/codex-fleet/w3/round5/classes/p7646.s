# n=5 model=out iset=I1 prefix14_class=7646
cmp P0, P2
cmovle S1, P2
cmovl P2, P0
cmovge S1, P0
cmp P3, P1
cmovle S2, P3
cmovge S2, P1
cmovge P1, P3
cmp P2, S2
cmovl P3, P2
cmovle P2, S2
cmovl S2, P3
cmp P1, S1
mov P0, S1
