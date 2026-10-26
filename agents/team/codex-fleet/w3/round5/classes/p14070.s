# n=5 model=out iset=I1 prefix14_class=14070
mov S2, P3
cmp P2, P0
cmovl S0, P2
cmovl P2, P0
mov S1, P2
cmovl P0, S0
cmp P1, S2
cmovl S2, P1
cmovl P1, P3
cmp P2, P1
cmovg S1, P1
cmovl P2, P1
cmp P0, S2
mov P2, S2
