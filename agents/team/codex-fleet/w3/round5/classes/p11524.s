# n=5 model=out iset=I1 prefix14_class=11524
mov S1, P2
cmp P3, P0
mov S2, P0
cmovle P0, P3
cmovge S2, P3
cmp P1, P2
cmovl S1, P1
cmovle P1, P2
mov P2, S2
cmp S1, P0
cmovle P3, S1
cmovl S1, P0
mov S0, S1
cmovl P0, P3
