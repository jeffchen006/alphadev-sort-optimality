# n=5 model=out iset=I1 prefix14_class=14058
cmp P0, P2
cmovl S1, P2
cmovge S1, P0
cmovl P2, P0
cmp P3, P1
cmovl P0, P1
mov S0, S1
cmovle P1, P3
cmovl P3, P0
cmp S1, P3
cmovle S1, P3
mov S1, P2
cmovge S0, P3
cmp P1, P2
