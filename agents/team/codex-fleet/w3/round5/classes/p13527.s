# n=5 model=out iset=I1 prefix14_class=13527
mov S2, P3
cmp P3, P1
cmovge S2, P1
cmovl P3, P1
cmp P0, P2
cmovl S1, P0
cmovl P0, P2
mov S0, S2
cmovl P2, S1
cmp P2, S2
cmovg S0, P2
cmovl S2, P2
mov P1, S0
mov S2, P0
