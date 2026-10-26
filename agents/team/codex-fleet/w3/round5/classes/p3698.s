# n=5 model=out iset=I1 prefix14_class=3698
mov S1, P2
cmp P3, S1
cmovge S1, P3
mov S0, P1
cmovg P3, P2
cmp P1, P0
mov P2, P3
cmovl P1, P0
cmovl P0, S0
cmp P2, P0
cmovl P2, P0
cmovl P0, P3
mov P0, P1
cmovl P3, P2
