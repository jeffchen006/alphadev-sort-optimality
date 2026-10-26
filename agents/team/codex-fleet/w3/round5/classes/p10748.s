# n=5 model=out iset=I1 prefix14_class=10748
mov S0, P3
cmp P2, S0
cmovl P3, P2
cmovge S0, P2
mov S2, S0
cmp P0, P1
cmovl P2, P0
cmovle P0, P1
cmovl P1, P2
cmp S2, P0
cmovl S2, P0
cmovl P0, S0
cmp P1, P3
mov S2, P3
