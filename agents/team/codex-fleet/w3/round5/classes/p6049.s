# n=5 model=out iset=I1 prefix14_class=6049
cmp P0, P1
cmovge S0, P0
cmovle S0, P1
cmovl P1, P0
cmp P2, P3
mov S1, S0
cmovle P0, P3
cmovl P3, P2
cmovl P2, P0
cmp P2, S1
cmovl S0, P2
cmovge S1, P2
cmp P1, P3
mov S1, P1
