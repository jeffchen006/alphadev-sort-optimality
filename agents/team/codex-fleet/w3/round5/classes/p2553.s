# n=5 model=out iset=I1 prefix14_class=2553
cmp P1, P2
cmovl S0, P1
cmovl P1, P2
cmovl P2, S0
cmp P0, P3
cmovle S2, P0
cmovl P0, P3
cmovle P3, S2
cmp P1, P0
mov S1, P1
cmovl S1, P0
cmovl P0, P1
mov S0, P2
mov P1, P0
