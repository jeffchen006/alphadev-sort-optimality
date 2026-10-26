# n=5 model=out iset=I1 prefix14_class=3650
mov S2, P0
cmp S2, P1
cmovl S2, P1
mov S0, P2
cmovle P1, P0
mov S1, P1
cmp P3, P2
cmovle P2, P3
cmovl P3, S0
cmp P2, S1
cmovl S1, P2
cmovg P1, P2
mov S0, P1
cmp P3, S2
