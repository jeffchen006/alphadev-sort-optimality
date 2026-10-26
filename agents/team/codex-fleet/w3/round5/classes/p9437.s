# n=5 model=out iset=I1 prefix14_class=9437
mov S1, P0
cmp P1, P0
cmovl P0, P1
cmovle P1, S1
cmp P2, P3
cmovl S0, P2
cmovl P2, P3
cmovl P3, S0
cmp P0, P3
cmovge S2, P0
cmovl S2, P3
cmovl P3, P0
mov S1, P1
mov P3, S2
