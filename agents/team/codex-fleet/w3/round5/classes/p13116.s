# n=5 model=out iset=I1 prefix14_class=13116
cmp P3, P0
mov S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P2, P1
cmovle S1, P2
cmovl P2, P1
mov S0, P2
cmovl P1, S1
cmp P1, P0
mov S2, P1
cmovl S2, P0
cmovl P0, P1
cmp S0, P3
