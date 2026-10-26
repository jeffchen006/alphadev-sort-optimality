# n=5 model=out iset=I1 prefix14_class=5985
cmp P1, P3
cmovge S0, P1
mov S2, P0
cmovle S0, P3
cmovl P3, P1
cmp P2, S2
cmovl P0, P2
mov S1, S0
cmovge S2, P2
cmp S2, S1
cmovl S1, S2
cmovle S2, S0
cmp P0, P3
cmovle P2, P3
