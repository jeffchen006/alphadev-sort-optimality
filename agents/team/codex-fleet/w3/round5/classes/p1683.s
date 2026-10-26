# n=5 model=out iset=I1 prefix14_class=1683
cmp P0, P1
cmovl S1, P1
cmovge S1, P0
cmovl P1, P0
cmp P3, P2
mov P0, P3
cmovle P3, P2
mov S2, P3
cmovg P0, P2
mov S0, P0
cmp P1, S0
cmovl S0, P1
cmovl P1, P0
mov P0, P1
