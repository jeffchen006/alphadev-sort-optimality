# n=5 model=out iset=I1 prefix14_class=9439
cmp P0, P1
cmovl S2, P1
cmovle P1, P0
cmovl P0, S2
mov S1, P3
cmp P3, P2
mov S0, P0
cmovl P3, P2
cmovl P2, S1
cmp P2, P1
mov S1, P1
cmovge S1, P2
cmovle P1, P2
cmp P3, S0
