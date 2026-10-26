# n=5 model=out iset=I1 prefix14_class=5501
cmp P2, P3
cmovl S0, P2
cmovle P2, P3
mov S2, P0
cmovl P3, S0
cmp P0, P1
cmovge S2, P1
mov S0, P3
cmovl P0, P1
cmp S0, S2
cmovl S0, S2
cmovle S2, P3
cmp P0, P2
cmovle P3, P0
