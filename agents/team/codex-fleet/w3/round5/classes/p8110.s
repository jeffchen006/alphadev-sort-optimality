# n=5 model=out iset=I1 prefix14_class=8110
cmp P3, P2
cmovge S2, P2
cmovle S2, P3
cmovl P3, P2
cmp P1, P0
cmovle S0, P0
mov S1, S2
cmovl P0, P1
cmovl P1, S0
cmp S1, P0
cmovl S1, P0
cmovg S2, P0
mov P0, P3
mov S2, S1
