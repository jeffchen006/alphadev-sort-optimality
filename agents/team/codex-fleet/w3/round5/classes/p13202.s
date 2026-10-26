# n=5 model=out iset=I1 prefix14_class=13202
cmp P3, P0
cmovle S1, P0
mov S0, P2
cmovle P0, P3
cmovle P3, S1
cmp P1, S0
cmovl S0, P1
cmovl P1, P2
cmovl P2, S0
cmp P0, S0
cmovl P2, P0
cmovl P0, S0
cmp P3, P1
cmovl S1, P1
