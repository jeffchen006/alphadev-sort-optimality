# n=5 model=out iset=I1 prefix14_class=11282
mov S1, P2
cmp P1, S1
cmovl S1, P1
cmovl P1, P2
cmp P3, P0
cmovge S0, P3
cmovl S0, P0
cmovge P3, P0
cmp P1, S0
cmovl P0, S0
cmovle S0, P1
cmovl P1, P0
mov P1, S0
mov S2, S1
