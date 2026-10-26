# n=5 model=out iset=I1 prefix14_class=4304
cmp P1, P0
mov S0, P1
cmovl S0, P0
cmovg P1, P0
mov P0, P3
mov S1, S0
cmp P3, P2
cmovl P3, P2
cmovge P0, P2
cmp P0, P1
cmovl P2, P0
cmovl P0, P1
cmovl P1, P2
cmp P3, S0
