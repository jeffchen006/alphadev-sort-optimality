# n=5 model=out iset=I1 prefix14_class=7771
mov S0, P2
cmp P2, P3
cmovge S0, P3
mov S1, P1
cmovl P2, P3
cmp P1, P0
cmovg P1, P0
cmovl S1, P0
cmp P1, S0
cmovg P3, S0
cmovge S0, P1
cmovg P1, P3
mov P1, S1
cmp P1, P2
