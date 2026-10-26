# n=5 model=out iset=I1 prefix14_class=752
cmp P2, P3
cmovge S2, P3
cmovl S2, P2
mov S0, P1
cmovle P2, P3
cmp P1, P0
cmovl P1, P0
mov P3, P1
cmovge S0, P0
cmp P1, P2
cmovle P1, P2
cmovle P2, P3
cmp S0, S2
cmovge S1, S0
