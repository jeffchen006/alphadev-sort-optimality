# n=5 model=out iset=I1 prefix14_class=5020
mov S1, P2
cmp P1, P2
cmovl S1, P1
mov S2, P3
cmovg P2, P1
cmp P0, P3
cmovle P3, P0
cmovl P0, S2
mov S0, S1
cmp P3, S1
cmovl S0, P3
mov S0, P0
cmovg S1, P3
cmp S0, P2
