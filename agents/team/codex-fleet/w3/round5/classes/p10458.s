# n=5 model=out iset=I1 prefix14_class=10458
cmp P3, P2
cmovl S1, P3
mov S2, P0
cmovl P3, P2
cmovl P2, S1
mov S1, P3
cmp P1, S2
cmovle S2, P1
cmovl P1, P0
cmp P3, P1
cmovl P3, P1
cmovl P1, S1
cmp P2, S2
cmovge S1, S2
