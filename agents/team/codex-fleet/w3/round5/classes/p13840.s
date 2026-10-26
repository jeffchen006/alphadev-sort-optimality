# n=5 model=out iset=I1 prefix14_class=13840
mov S2, P0
cmp P0, P2
cmovge S2, P2
cmovl P0, P2
mov S1, P3
cmp P1, S1
cmovge S1, P1
cmovle P3, P1
cmp P0, S1
cmovl S0, S1
cmovl P1, P3
cmovle S1, P0
cmovl P0, S0
cmp S2, P3
