# n=5 model=out iset=I1 prefix14_class=7480
cmp P1, P2
cmovge S1, P2
cmovl S1, P1
cmovl P1, P2
cmp P3, P0
cmovl P2, P3
cmovge P2, P0
cmovl P3, P0
cmp P2, S1
cmovle S0, P2
cmovle P2, S1
cmovl S1, S0
cmp P1, P3
cmovl P0, P1
