# n=5 model=out iset=I1 prefix14_class=10045
mov S2, P2
cmp P2, P1
cmovl S2, P1
cmovle P1, P2
mov S0, P0
cmp P3, S0
cmovl S0, P3
mov S1, S2
cmovl P3, P0
cmp P3, S1
cmovge S2, P3
cmovg P3, S1
mov P0, P1
mov S2, P3
