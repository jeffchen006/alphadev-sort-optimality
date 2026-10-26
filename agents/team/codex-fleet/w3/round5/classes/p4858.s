# n=5 model=out iset=I1 prefix14_class=4858
mov S1, P3
mov S0, P0
cmp P0, P1
cmovg P0, P1
cmovl S0, P1
mov S2, P0
cmp P2, P3
cmovg S1, P2
cmovl P3, P2
cmp S2, P3
cmovl S2, P3
cmovle P3, P0
cmp S0, S1
mov P0, S0
