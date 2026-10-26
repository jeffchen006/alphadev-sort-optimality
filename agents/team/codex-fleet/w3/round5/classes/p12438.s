# n=5 model=out iset=I1 prefix14_class=12438
mov S0, P0
cmp S0, P2
cmovle S0, P2
cmovle P2, P0
cmp P3, P1
cmovge S1, P1
cmovl S1, P3
cmovl P3, P1
cmp P2, S1
cmovle P1, S1
cmovl S1, P2
cmovle P2, P1
cmp P3, S0
cmovl S1, P3
