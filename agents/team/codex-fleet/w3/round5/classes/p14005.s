# n=5 model=out iset=I1 prefix14_class=14005
mov S0, P2
cmp P1, P0
cmovl S2, P0
cmovl P0, P1
cmovl P1, S2
cmp P3, S0
cmovg S0, P3
cmovle P2, P3
mov S1, P1
cmp S1, S0
cmovl P1, S0
cmovl S0, S1
mov S1, P0
cmp P0, P2
