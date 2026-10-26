# n=5 model=out iset=I1 prefix14_class=1145
mov S2, P2
cmp P3, P1
cmovl S1, P3
cmovle P3, P1
cmovl P1, S1
cmp S2, P0
cmovl P2, P0
cmovge S2, P0
cmp P2, P3
mov S0, P2
cmovl S0, P3
cmovle P3, P2
cmp S2, P1
cmovge S1, P1
