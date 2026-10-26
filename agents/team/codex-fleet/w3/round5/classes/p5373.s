# n=5 model=out iset=I1 prefix14_class=5373
cmp P0, P2
cmovl S2, P2
cmovl P2, P0
mov S1, P3
cmovl P0, S2
mov S0, P2
cmp P1, S1
cmovl S1, P1
cmovle P1, P3
cmp S1, S0
cmovge P2, S1
mov P3, P0
cmovl S0, S1
cmp P0, P1
