# n=5 model=out iset=I1 prefix14_class=10644
cmp P0, P3
mov S0, P3
cmovl S0, P0
cmovl P0, P3
cmp P2, P1
cmovle P3, P1
cmovle P1, P2
cmovle P2, P3
mov S1, P2
cmp S1, P0
mov S2, P1
cmovg P2, P0
cmovl S1, P0
cmp S0, P1
