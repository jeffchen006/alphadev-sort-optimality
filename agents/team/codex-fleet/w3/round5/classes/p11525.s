# n=5 model=out iset=I1 prefix14_class=11525
mov S2, P0
cmp P3, P0
cmovl P0, P3
cmovge S2, P3
mov S0, P2
cmp P1, S0
cmovl S0, P1
cmovle P1, P2
cmp S0, P0
cmovle P2, S0
cmovl S0, P0
mov S1, S0
cmovl P0, P2
mov P3, S2
