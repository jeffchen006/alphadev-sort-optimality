# n=5 model=out iset=I1 prefix14_class=14498
mov S2, P3
cmp S2, P2
cmovg P3, P2
cmovg P2, S2
cmp P0, P1
mov S0, P1
cmovle P1, P0
cmovl P0, S0
cmp P1, P3
cmovl S2, P1
cmovle P1, P3
mov S1, P2
cmovl P3, S2
cmp S1, P0
