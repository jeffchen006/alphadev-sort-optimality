# n=5 model=out iset=I1 prefix14_class=6939
cmp P0, P1
cmovge S1, P0
cmovge P0, P1
cmovl S1, P1
mov P1, P2
cmp P3, P2
cmovl P2, P3
cmovge P1, P3
cmp S1, P1
cmovle S0, P1
cmovl P1, S1
cmovl S1, S0
cmp P2, P0
cmovl S2, P0
