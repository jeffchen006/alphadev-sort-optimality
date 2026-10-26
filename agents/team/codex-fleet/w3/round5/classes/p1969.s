# n=5 model=out iset=I1 prefix14_class=1969
cmp P1, P2
cmovge S0, P2
mov S1, P0
cmovl S0, P1
cmovl P1, P2
cmp P3, S1
cmovle P0, P3
cmovge S1, P3
mov P3, P1
cmp P1, S1
cmovl P3, S1
cmovl S1, P1
cmp P0, S0
cmovl P3, P0
