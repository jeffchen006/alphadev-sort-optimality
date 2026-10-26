# n=5 model=out iset=I1 prefix14_class=6519
mov S0, P2
cmp P2, P1
cmovge P2, P1
cmovge P1, S0
cmp P3, P0
cmovl S0, P0
cmovl P0, P3
cmovl P3, S0
cmp P3, P1
cmovl S0, P3
cmovl P3, P1
cmovl P1, S0
mov S1, P2
cmp P0, S1
