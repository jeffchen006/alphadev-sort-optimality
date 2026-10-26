# n=5 model=out iset=I1 prefix14_class=14271
cmp P1, P3
cmovle S0, P3
mov S1, P0
cmovl P3, P1
cmovle P1, S0
cmp P0, P2
cmovl S1, P2
cmovl P2, P0
cmovl P0, S1
cmp S1, P1
cmovl S1, P1
cmovl P1, P0
cmp P3, P2
mov S1, P1
