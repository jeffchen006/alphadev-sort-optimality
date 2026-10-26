# n=5 model=out iset=I1 prefix14_class=3130
cmp P0, P3
cmovge S1, P3
mov S0, P1
cmovg P3, P0
cmovl S1, P0
cmp P2, S0
cmovl P1, P2
cmovge S0, P2
mov P0, P1
cmp P1, S1
cmovge P0, S1
cmovl P1, S1
cmp P3, S0
cmovle S1, P1
