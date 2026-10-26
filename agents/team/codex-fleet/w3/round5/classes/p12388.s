# n=5 model=out iset=I1 prefix14_class=12388
mov S0, P0
cmp S0, P2
cmovg S0, P2
cmovle P0, P2
cmp P1, P3
cmovl P2, P3
cmovl P3, P1
cmovl P1, P2
mov S2, S0
mov S1, P1
cmp P3, S0
cmovl S0, P3
cmovle P3, S2
cmovg S2, P3
