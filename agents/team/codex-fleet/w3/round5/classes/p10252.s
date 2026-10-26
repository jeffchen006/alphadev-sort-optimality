# n=5 model=out iset=I1 prefix14_class=10252
mov S1, P1
cmp P1, P3
cmovge S1, P3
mov S0, P2
cmovl P1, P3
cmp S0, P0
cmovg S0, P0
cmovl P2, P0
cmp P1, P2
cmovl S2, P1
cmovl P1, P2
cmovl P2, S2
cmp S0, S1
cmovle P0, S1
