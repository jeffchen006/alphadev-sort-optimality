# n=5 model=out iset=I1 prefix14_class=1605
cmp P0, P2
cmovge S0, P0
cmovl S0, P2
cmovge P0, P2
cmp P1, P3
mov P2, P3
cmovg P3, P1
cmovl P2, P1
mov S2, P0
cmp P0, P2
cmovl S2, P2
cmovl P2, P0
cmovl P0, S2
mov S1, S0
