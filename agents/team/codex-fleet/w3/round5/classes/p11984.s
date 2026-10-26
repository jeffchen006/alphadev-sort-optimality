# n=5 model=out iset=I1 prefix14_class=11984
cmp P2, P3
mov S2, P0
cmovl S1, P2
cmovl P2, P3
cmovge S1, P3
cmp P0, P1
cmovl S2, P1
cmovl P1, P0
cmp P1, S1
cmovle S0, S1
cmovle S1, P1
cmovl P1, S0
cmp P2, S2
cmovl S0, P2
