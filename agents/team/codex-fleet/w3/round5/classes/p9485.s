# n=5 model=out iset=I1 prefix14_class=9485
cmp P1, P0
mov S1, P2
cmovl S2, P0
cmovge S2, P1
cmovl P0, P1
cmp S1, P3
cmovge S1, P3
cmovge P3, P2
cmp P0, S1
cmovle S0, S1
cmovl S1, P0
cmovl P0, S0
cmp S2, P3
mov P1, P3
