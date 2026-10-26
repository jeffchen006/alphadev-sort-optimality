# n=5 model=out iset=I1 prefix14_class=13234
cmp P0, P3
mov S0, P2
cmovle S2, P3
cmovl P3, P0
cmovle P0, S2
mov S1, P0
cmp P2, P1
cmovge S0, P1
cmovl P2, P1
cmp S0, P3
cmovl S2, P3
cmovl P3, S0
cmovl S0, S2
cmp S1, P2
