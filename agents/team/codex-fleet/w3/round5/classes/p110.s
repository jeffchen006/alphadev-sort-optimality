# n=5 model=out iset=I1 prefix14_class=110
cmp P2, P3
cmovge S2, P2
cmovl S2, P3
mov S0, P0
cmovg P2, P3
cmp P1, P0
cmovge S0, P1
cmovl P0, P1
cmp P0, P2
cmovl S1, P2
cmovle P2, P0
cmovl P0, S1
mov P2, S0
cmp P2, S2
