# n=5 model=out iset=I1 prefix14_class=11689
cmp P1, P3
mov S2, P1
cmovle P1, P3
mov S1, P0
cmovle P3, S2
cmp P2, S1
cmovg P0, P2
cmovl S1, P2
cmp P1, P0
cmovl S0, P0
cmovl P0, P1
cmovl P1, S0
cmp S1, P3
cmovl S0, P3
