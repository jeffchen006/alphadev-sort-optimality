# n=5 model=out iset=I1 prefix14_class=7371
cmp P2, P1
cmovl S1, P2
cmovl P2, P1
cmovl P1, S1
mov S0, P0
cmp P3, P0
cmovl P0, P3
cmovge S0, P3
cmp P0, P1
cmovle S1, P0
cmovl P0, P1
mov P3, S0
cmovle P1, S1
cmp P2, P3
