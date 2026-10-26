# n=5 model=out iset=I1 prefix14_class=1881
mov S1, P0
mov S0, P2
cmp P1, P2
cmovl P2, P1
cmovl P1, S0
cmp P3, S1
mov S0, P1
cmovl S1, P3
cmovg P0, P3
cmp P0, P1
cmovl S0, P0
cmovl P0, P1
mov P1, S0
mov P0, S1
