# n=5 model=out iset=I1 prefix14_class=1921
mov S2, P3
cmp P0, S2
cmovl P3, P0
cmovl P0, S2
cmp P2, P1
cmovl S1, P1
cmovl P1, P2
cmovge S1, P2
cmp P0, S1
mov S0, P0
cmovle P0, S1
cmovge S0, S1
mov P0, S0
cmp P3, P1
