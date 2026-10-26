# n=5 model=out iset=I1 prefix14_class=10700
mov S0, P0
cmp P0, P2
cmovl P0, P2
mov S2, P3
cmovge S0, P2
cmp P1, P3
mov S1, P0
cmovl P3, P1
cmovge S2, P1
cmp S2, S1
cmovl P0, S2
cmovl S2, S1
mov S2, P3
cmovle S1, P0
