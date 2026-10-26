# n=5 model=out iset=I1 prefix14_class=11953
cmp P2, P3
mov S1, P2
cmovl S1, P3
cmovle P3, P2
mov S0, P1
cmp S0, P0
cmovle S0, P0
cmovl P0, P1
cmp S1, S0
cmovge S2, S1
cmovge S1, S0
cmovge S0, S2
cmp P0, P3
cmovle S0, P0
