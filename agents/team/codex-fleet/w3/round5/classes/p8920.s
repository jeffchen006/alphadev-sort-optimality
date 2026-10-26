# n=5 model=out iset=I1 prefix14_class=8920
cmp P2, P1
cmovl S2, P1
cmovl P1, P2
mov S1, P3
cmovl P2, S2
cmp P0, P3
cmovl S1, P0
cmovle P0, P3
cmp P2, P0
cmovle S0, P2
cmovge S0, P0
cmovl P2, P0
mov P2, S1
cmp P1, P2
