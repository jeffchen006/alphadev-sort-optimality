# n=5 model=out iset=I1 prefix14_class=6679
cmp P0, P1
cmovl S1, P1
cmovle P1, P0
cmovl P0, S1
mov S2, P3
cmp P2, P3
cmovl P3, P2
cmovl P2, S2
cmp P2, P0
cmovl S0, P0
cmovge S0, P2
cmovl P0, P2
cmp P3, P1
cmovle S2, P1
