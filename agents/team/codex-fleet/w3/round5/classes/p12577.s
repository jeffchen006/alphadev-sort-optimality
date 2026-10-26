# n=5 model=out iset=I1 prefix14_class=12577
cmp P3, P0
cmovge S2, P3
cmovg P3, P0
cmovl S2, P0
cmp P2, P1
cmovle P0, P1
mov S0, P3
cmovl P1, P2
cmovl P2, P0
cmp P1, P3
cmovle P3, P1
cmovl P1, S0
cmp P2, S2
cmovl P0, P2
