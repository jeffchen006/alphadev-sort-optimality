# n=5 model=out iset=I1 prefix14_class=14124
mov S0, P3
cmp P1, P0
cmovge S2, P1
cmovge P1, P0
cmovge P0, S2
cmp P2, S0
cmovl P3, P2
cmovge S0, P2
cmp S0, P0
cmovl S1, S0
cmovle S0, P0
cmovl P0, S1
mov P2, P3
cmp P1, P2
