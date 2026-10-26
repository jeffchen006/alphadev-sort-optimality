# n=5 model=out iset=I1 prefix14_class=8017
mov S1, P2
cmp S1, P1
cmovl S1, P1
cmovg P2, P1
mov S0, P3
mov S2, S1
cmp P3, P0
cmovl P3, P0
cmovge S0, P0
cmp S0, P2
cmovle P0, S0
cmovl S0, P2
cmovle P2, P0
cmp S1, P3
