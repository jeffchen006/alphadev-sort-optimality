# n=5 model=out iset=I1 prefix14_class=3690
cmp P0, P2
cmovl S1, P2
cmovge S1, P0
cmovle P2, P0
cmp P3, P1
cmovle S0, P3
cmovle P3, P1
mov S2, P2
cmovl P1, S0
cmp P2, P1
cmovl S2, P1
cmovl P1, P2
mov P1, P3
cmp S1, P1
