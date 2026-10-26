# n=5 model=out iset=I1 prefix14_class=4014
cmp P3, P1
mov S0, P0
cmovl S1, P3
cmovge S1, P1
cmovl P3, P1
cmp P0, P2
cmovge S0, P2
mov P1, S1
cmovge P2, P0
cmp P1, S0
cmovg S1, S0
cmovge S0, P1
cmp P3, P2
cmovl P1, P2
