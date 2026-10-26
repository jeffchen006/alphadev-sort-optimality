# n=5 model=out iset=I1 prefix14_class=11053
mov S2, P0
mov S0, P2
cmp P1, P2
cmovl P2, P1
cmovge S0, P1
cmp P0, P3
cmovle P0, P3
cmovle P3, S2
cmp S0, P0
cmovl S2, S0
mov P1, P3
cmovl S0, P0
cmovl P0, S2
mov S0, P0
