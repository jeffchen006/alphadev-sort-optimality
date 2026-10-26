# n=5 model=out iset=I1 prefix14_class=8379
mov S2, P0
cmp P0, P2
mov S0, P3
cmovle P0, P2
cmovl P2, S2
cmp S0, P1
cmovg S0, P1
cmovg P1, P3
mov P3, S0
cmp P0, P1
cmovl S1, P0
cmovl P0, P1
cmovl P1, S1
cmp P3, P2
