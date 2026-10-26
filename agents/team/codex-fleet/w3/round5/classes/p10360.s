# n=5 model=out iset=I1 prefix14_class=10360
cmp P3, P2
mov S0, P2
cmovge S0, P3
cmovl P2, P3
mov S1, P0
cmp P1, P0
cmovl P0, P1
cmovle P1, S1
cmp P1, S0
cmovl P3, S0
cmovl S0, P1
mov S2, S0
mov S1, P0
cmovl P1, P3
