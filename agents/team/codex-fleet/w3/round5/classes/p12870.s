# n=5 model=out iset=I1 prefix14_class=12870
cmp P0, P2
mov S0, P1
cmovl S2, P2
cmovle P2, P0
cmovl P0, S2
cmp P3, S0
cmovl S0, P3
cmovl P3, P1
mov S1, S0
cmp S0, P2
cmovg S1, P2
mov P1, P3
cmovl S0, P2
mov S1, S0
