# n=5 model=out iset=I1 prefix14_class=8467
mov S0, P3
cmp P3, P0
cmovl P3, P0
mov S1, P1
cmovge S0, P0
cmp P1, P2
cmovl P1, P2
cmovl P2, S1
cmp P3, P1
cmovle S1, P1
cmovl P1, P3
cmovl P3, S1
cmp P2, S0
cmovge S1, P2
