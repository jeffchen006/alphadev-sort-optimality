# n=5 model=out iset=I1 prefix14_class=3668
cmp P2, P0
cmovle S2, P0
cmovge S2, P2
cmovle P0, P2
cmp P1, P3
cmovl P2, P1
cmovl P1, P3
cmovl P3, P2
cmp P3, P0
mov S0, S2
cmovge S1, P3
cmovl S1, P0
cmovle P0, P3
cmovle P3, S1
