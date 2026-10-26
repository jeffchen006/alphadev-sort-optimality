# n=5 model=out iset=I1 prefix14_class=7153
mov S1, P1
cmp P2, S1
cmovg P1, P2
cmovl S1, P2
cmp P3, P0
cmovl P2, P3
cmovle P3, P0
mov S2, S1
cmovl P0, P2
cmp S2, P0
cmovl S1, P0
cmovg S2, P0
cmp P1, P3
mov S0, P1
