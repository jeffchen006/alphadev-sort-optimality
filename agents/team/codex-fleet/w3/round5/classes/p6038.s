# n=5 model=out iset=I1 prefix14_class=6038
cmp P0, P3
cmovle S0, P3
cmovl P3, P0
cmovge S0, P0
cmovl P0, S0
mov S2, P2
cmp P1, P2
cmovl S2, P1
cmovle P1, P2
cmp P1, S0
cmovge P0, P1
cmovl S0, P1
cmp S2, P3
cmovl P1, S2
