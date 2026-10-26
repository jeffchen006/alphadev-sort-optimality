# n=5 model=out iset=I1 prefix14_class=1149
cmp P3, P1
cmovl S0, P3
cmovle P3, P1
cmovl P1, S0
mov S1, P0
cmp S1, P2
cmovg P0, P2
cmovl S1, P2
cmp S1, P3
mov S2, S1
cmovl S2, P3
cmovl P3, S1
cmp P1, P0
cmovl S0, P0
