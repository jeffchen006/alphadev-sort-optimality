# n=5 model=out iset=I1 prefix14_class=14026
cmp P3, P0
cmovl S2, P3
cmovge S2, P0
cmovl P3, P0
mov S0, P3
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
cmovl P2, S1
cmp S0, P1
cmovl P3, P1
mov P0, S2
cmovle P1, S0
mov S0, P1
