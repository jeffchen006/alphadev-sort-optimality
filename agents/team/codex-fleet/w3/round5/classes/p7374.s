# n=5 model=out iset=I1 prefix14_class=7374
cmp P2, P1
mov S1, P2
cmovl P2, P1
cmovl P1, S1
mov S1, P0
cmp P3, S1
cmovle P0, P3
cmovge S1, P3
cmp P1, P0
cmovl S0, P1
cmovl P1, P0
cmovl P0, S0
mov P3, S1
cmp P2, P3
