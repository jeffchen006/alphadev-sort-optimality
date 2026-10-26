# n=5 model=out iset=I1 prefix14_class=10910
cmp P2, P0
mov S2, P2
cmovle P2, P0
cmovl P0, S2
cmp P1, P3
cmovle S1, P3
cmovl P3, P1
cmovge S1, P1
cmp S1, P2
cmovle S0, S1
cmovl S1, P2
cmovle P2, S0
cmp P0, P3
cmovle S0, P3
