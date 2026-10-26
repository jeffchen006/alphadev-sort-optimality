# n=5 model=out iset=I1 prefix14_class=11052
mov S2, P0
mov S0, P2
cmp P1, P2
cmovl P2, P1
cmovge S0, P1
cmp S2, P3
cmovle S2, P3
cmovle P3, P0
cmp S0, S2
cmovl P0, S0
mov S1, P3
cmovl S0, S2
cmovl S2, P0
mov S0, S2
