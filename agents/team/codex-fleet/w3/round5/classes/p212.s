# n=5 model=out iset=I1 prefix14_class=212
cmp P2, P1
cmovl S0, P2
mov S2, P0
cmovl P2, P1
cmovl P1, S0
cmp P0, P3
cmovg P0, P3
mov S1, P0
cmovg P3, S2
cmp S1, P1
mov S0, P3
cmovl S1, P1
mov S2, S1
cmovle P1, P0
