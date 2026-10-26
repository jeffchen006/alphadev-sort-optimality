# n=5 model=out iset=I1 prefix14_class=12560
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
mov S2, P0
cmp P0, P2
cmovge S2, P2
cmovl P0, P2
cmp P1, S2
mov P2, P0
cmovle S0, S2
cmovl S2, P1
cmovle P1, S0
cmp P2, P3
