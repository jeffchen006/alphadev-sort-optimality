# n=5 model=out iset=I1 prefix14_class=14444
cmp P0, P3
cmovl S1, P3
cmovge S1, P0
cmovle P3, P0
mov S2, P1
mov S0, S1
cmp S2, P2
cmovl P1, P2
cmovge S2, P2
cmp S2, P3
cmovl P2, P3
cmovle P3, S2
cmovl S2, P2
cmp P1, S1
