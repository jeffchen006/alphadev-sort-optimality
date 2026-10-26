# n=5 model=out iset=I1 prefix14_class=2721
mov S0, P1
cmp P1, P3
cmovl P1, P3
cmovl P3, S0
mov S1, P2
cmp P2, P0
cmovl S1, P0
cmovl P0, P2
cmovl P2, S1
cmp P1, S1
cmovl S1, P1
cmovle P1, P2
cmp P0, P3
cmovge S0, P0
