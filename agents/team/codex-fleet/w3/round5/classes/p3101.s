# n=5 model=out iset=I1 prefix14_class=3101
cmp P3, P1
cmovle S0, P3
cmovge S0, P1
cmovl P3, P1
cmp P0, P2
cmovl S2, P2
cmovl P2, P0
mov S1, P3
cmovl P0, S2
cmp P2, S0
cmovl P1, P2
cmovge P1, S0
cmovl P2, S0
cmp S1, P0
