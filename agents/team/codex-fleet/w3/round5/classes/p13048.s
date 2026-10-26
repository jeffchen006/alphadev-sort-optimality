# n=5 model=out iset=I1 prefix14_class=13048
mov S0, P0
cmp P2, P0
cmovl P0, P2
cmovg S0, P2
cmp P3, P1
cmovl S1, P3
cmovl P3, P1
cmovl P1, S1
mov P2, S0
mov S2, P0
cmp S2, P1
cmovl P0, P1
cmovl P1, S2
mov P1, P0
