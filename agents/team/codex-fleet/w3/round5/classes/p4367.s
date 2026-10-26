# n=5 model=out iset=I1 prefix14_class=4367
cmp P1, P2
mov S0, P1
cmovl P1, P2
mov S1, P3
cmovge S0, P2
cmp P0, P3
cmovle S1, P0
mov P2, P1
cmovle P0, P3
cmp S1, S0
cmovle P3, S1
cmovl S1, S0
cmovl S0, P3
cmp P1, P0
