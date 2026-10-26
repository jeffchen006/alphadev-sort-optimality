# n=5 model=out iset=I1 prefix14_class=8098
mov S2, P3
cmp P3, P0
cmovl P3, P0
cmovge S2, P0
cmp P1, P2
mov S1, P2
cmovg P2, P1
cmovg P1, S1
cmp P1, S2
cmovl S0, S2
cmovle S2, P1
cmovl P1, S0
mov P0, P2
cmp P3, P2
