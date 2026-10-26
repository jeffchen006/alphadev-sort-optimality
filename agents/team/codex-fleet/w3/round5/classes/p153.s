# n=5 model=out iset=I1 prefix14_class=153
cmp P1, P3
cmovle S1, P1
mov S2, P0
cmovl P1, P3
cmovge S1, P3
cmp P2, P0
cmovle P0, P2
cmovl P2, S2
mov S2, P2
cmp S1, P0
cmovl S0, P0
cmovge S0, S1
cmovge S1, P0
cmp P1, P2
