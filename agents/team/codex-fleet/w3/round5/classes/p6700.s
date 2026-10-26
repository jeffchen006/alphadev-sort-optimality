# n=5 model=out iset=I1 prefix14_class=6700
mov S0, P3
cmp P1, P3
cmovle P3, P1
mov S2, P0
cmovl P1, S0
cmp P2, P0
cmovl S2, P2
cmovg P0, P2
cmp P1, P0
mov S1, P0
cmovg S1, P1
cmovl P0, P1
cmp S2, P3
cmovg P1, P3
