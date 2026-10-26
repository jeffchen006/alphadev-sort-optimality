# n=5 model=out iset=I1 prefix14_class=13541
mov S0, P3
cmp P3, P0
cmovle P3, P0
mov S1, P2
cmovge S0, P0
cmp P1, P2
cmovle P2, P1
cmovg S1, P1
cmp S0, P2
cmovl P0, S0
cmovl S0, P2
cmovl P2, P0
mov S2, S0
cmp S1, P3
