# n=5 model=out iset=I1 prefix14_class=6571
cmp P2, P1
cmovge S2, P2
mov S0, P0
cmovle S2, P1
cmovge P2, P1
cmp P0, P3
cmovle S0, P3
cmovl P3, P0
cmp S0, S2
cmovl P1, S2
cmovl S2, S0
cmovl S0, P1
mov S1, S2
cmp P3, P2
