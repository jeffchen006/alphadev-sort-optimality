# n=5 model=out iset=I1 prefix14_class=13044
mov S0, P0
cmp P2, S0
cmovl P0, P2
cmovge S0, P2
cmp P3, P1
cmovle P2, P3
cmovle P3, P1
cmovl P1, P2
mov S1, P0
cmp P0, P1
cmovl P0, P1
cmovl P1, S1
cmp P3, S0
mov P1, S0
