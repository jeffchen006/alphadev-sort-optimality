# n=5 model=out iset=I1 prefix14_class=6067
cmp P2, P0
mov S0, P2
mov S1, P3
cmovl S0, P0
cmovle P0, P2
cmp P3, P1
cmovl P3, P1
cmovl P1, S1
cmp S0, P3
cmovl S1, P3
cmovle P3, S0
cmovl S0, S1
cmp P0, P1
mov S2, P0
