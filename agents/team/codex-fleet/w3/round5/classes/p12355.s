# n=5 model=out iset=I1 prefix14_class=12355
mov S1, P3
cmp S1, P1
cmovl S1, P1
cmovl P1, P3
mov S2, P1
cmp P2, P0
cmovl P3, P2
cmovle P2, P0
cmovge P3, P0
cmp S2, P3
cmovl P1, P3
cmovle P3, S2
cmp P2, S1
cmovl S0, P2
