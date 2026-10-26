# n=5 model=out iset=I1 prefix14_class=2357
cmp P3, P0
cmovl S0, P3
cmovl P3, P0
cmovl P0, S0
cmp P1, P2
cmovge S2, P1
cmovl S2, P2
cmovg P1, P2
cmp P3, S2
mov S1, S2
cmovge S1, P3
cmovle S2, P3
cmp P0, P1
mov P3, S2
