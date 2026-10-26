# n=5 model=out iset=I1 prefix14_class=1602
cmp P3, P1
mov S0, P3
mov S1, P0
cmovl P3, P1
cmovg S0, P1
cmp P2, S1
cmovg S1, P2
cmovle P0, P2
mov P1, S0
cmp S0, P0
mov S2, S1
cmovl S0, P0
cmovl P0, P1
cmovl P1, S0
