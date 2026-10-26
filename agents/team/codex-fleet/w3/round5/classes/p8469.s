# n=5 model=out iset=I1 prefix14_class=8469
cmp P1, P0
mov S0, P1
cmovge S0, P0
mov S1, P2
cmovle P1, P0
cmp P2, P3
cmovl P2, P3
cmovle P3, S1
cmp P2, P1
cmovl S1, P1
cmovle P1, P2
mov S2, P1
cmovl P2, S1
cmp S0, P3
