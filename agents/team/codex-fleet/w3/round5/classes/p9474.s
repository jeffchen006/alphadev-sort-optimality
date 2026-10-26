# n=5 model=out iset=I1 prefix14_class=9474
mov S0, P3
cmp P2, P1
cmovge S1, P2
cmovl S1, P1
cmovl P1, P2
cmp S0, P0
cmovge S0, P0
cmovg P0, P3
cmp S0, P1
cmovle P3, P1
cmovle P1, S0
cmovl S0, P3
cmp S1, P0
cmovl P1, S1
