# n=5 model=out iset=I1 prefix14_class=3590
mov S1, P2
cmp S1, P3
mov S0, P1
cmovle P2, P3
cmovle P3, S1
cmp P0, P1
cmovle P1, P0
cmovge S0, P0
cmp P1, P3
cmovl S1, P3
cmovle P3, P1
mov P0, S0
cmovl P1, S1
cmp P0, P2
