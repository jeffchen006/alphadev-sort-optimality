# n=5 model=out iset=I1 prefix14_class=5374
cmp P2, P3
cmovl S2, P3
cmovle P3, P2
mov S1, P3
mov S0, P1
cmovl P2, S2
cmp P0, S0
cmovl P1, P0
cmovl P0, S0
cmp P1, P3
cmovl P3, P1
cmovge S1, P1
mov P3, P2
cmp P2, P0
