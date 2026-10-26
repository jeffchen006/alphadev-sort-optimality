# n=5 model=out iset=I1 prefix14_class=7630
cmp P0, P3
cmovl S1, P0
cmovle P0, P3
cmovl P3, S1
mov S0, P1
cmp P2, P1
cmovg S0, P2
cmovl P1, P2
cmp P1, P3
mov S2, P1
cmovl P1, P3
cmovl P3, S2
mov P3, S0
cmp P0, S0
