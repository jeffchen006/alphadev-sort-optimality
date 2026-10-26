# n=5 model=out iset=I1 prefix14_class=7368
cmp P2, P3
cmovl S1, P2
cmovl P2, P3
mov S0, P0
cmovl P3, S1
cmp P1, P0
cmovge S0, P1
cmovle P0, P1
cmp P0, P3
cmovle P1, P0
cmovl P0, P3
cmovle P3, P1
cmp P2, S0
mov S2, S0
