# n=5 model=out iset=I1 prefix14_class=14084
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
cmovl P2, S0
cmp P1, P3
cmovle S2, P3
cmovge S2, P1
cmovle P3, P1
cmovl P1, S2
cmp P0, S2
cmovl S2, P0
cmovl P0, P1
cmp P2, P3
cmovle S1, P3
