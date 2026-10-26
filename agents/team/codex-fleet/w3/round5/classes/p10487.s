# n=5 model=out iset=I1 prefix14_class=10487
cmp P1, P0
cmovl S1, P0
cmovle P0, P1
cmovl P1, S1
mov S2, P2
cmp P3, P2
cmovl S2, P3
cmovg P2, P3
cmp P2, P1
cmovl S1, P1
cmovle P1, P2
cmovl P2, S1
mov S0, P0
cmp S2, S0
