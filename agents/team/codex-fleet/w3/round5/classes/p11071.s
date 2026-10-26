# n=5 model=out iset=I1 prefix14_class=11071
mov S0, P1
cmp S0, P2
cmovl S0, P2
cmovl P2, P1
mov S1, P3
cmp S1, P0
cmovl S1, P0
cmovle P0, P3
cmp S1, S0
cmovl P3, S0
cmovl S0, S1
cmovl S1, P3
cmp P0, P2
cmovge S1, P0
