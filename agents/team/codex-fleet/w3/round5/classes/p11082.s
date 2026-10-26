# n=5 model=out iset=I1 prefix14_class=11082
mov S2, P2
cmp P3, P0
cmovge S1, P3
cmovle S1, P0
cmovl P0, P3
cmp S2, P1
cmovl P2, P1
cmovle P1, S2
cmp P2, S1
cmovle P3, S1
mov S0, P1
cmovl S1, P2
cmovl P2, P3
cmp P1, P0
