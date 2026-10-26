# n=5 model=out iset=I1 prefix14_class=4359
mov S0, P0
cmp P1, P2
cmovle S1, P1
cmovle P1, P2
cmovge S1, P2
cmp P3, P0
cmovl P0, P3
cmovle P3, S0
cmp P0, S1
cmovl S2, P0
cmovl P0, S1
cmovl S1, S2
cmp P3, P1
cmovge S2, P3
