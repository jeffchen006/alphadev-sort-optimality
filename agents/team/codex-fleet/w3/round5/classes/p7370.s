# n=5 model=out iset=I1 prefix14_class=7370
mov S0, P0
cmp P2, P3
cmovl S1, P2
cmovl P2, P3
cmovl P3, S1
cmp P1, P0
cmovge S0, P1
cmovl P0, P1
cmp P0, P3
cmovle S1, P0
cmovl P0, P3
cmovle P3, S1
mov P1, S0
cmp P2, P1
