# n=5 model=out iset=I1 prefix14_class=9806
cmp P2, P3
cmovle S0, P2
cmovl P2, P3
cmovl P3, S0
cmp P0, P1
mov S2, P3
mov S0, P1
cmovge S0, P0
cmovle P1, P0
cmp S0, P2
cmovl P0, S0
cmovl S0, P2
cmovl P2, P0
cmp P3, P1
