# n=5 model=out iset=I1 prefix14_class=9822
cmp P2, P1
cmovl S1, P1
cmovle P1, P2
cmovl P2, S1
cmp P0, P3
cmovl S1, P3
mov S2, P2
cmovl P3, P0
cmovl P0, S1
cmp P0, P2
mov S0, P3
cmovge S2, P0
cmovg P0, P2
cmp P3, P1
