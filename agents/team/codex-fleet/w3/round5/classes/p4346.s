# n=5 model=out iset=I1 prefix14_class=4346
cmp P1, P3
cmovl S0, P1
cmovl P1, P3
cmovge S0, P3
cmp P0, P2
mov P3, P2
cmovle P2, P0
cmovle P0, P3
cmp S0, P2
mov S1, S0
cmovl S0, P2
cmovle P2, S1
mov P2, S0
mov S2, P0
