# n=5 model=out iset=I1 prefix14_class=1094
cmp P3, P0
cmovl S1, P3
cmovle P3, P0
cmovl P0, S1
mov S0, P1
cmp S0, P2
mov S2, P3
cmovge S0, P2
cmovl P1, P2
cmp S2, P1
cmovl P3, P1
cmovl P1, S2
mov S2, S0
cmp P0, S0
