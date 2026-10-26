# n=5 model=out iset=I1 prefix14_class=10546
mov S1, P3
cmp S1, P1
mov S0, P0
cmovl P3, P1
cmovle P1, S1
cmp P2, S0
cmovg S0, P2
cmovl P0, P2
cmp S0, P3
cmovl S1, S0
cmovl S0, P3
cmovl P3, S1
cmp P0, P1
mov S0, P1
