# n=5 model=out iset=I1 prefix14_class=5011
cmp P2, P0
mov S1, P2
mov S2, P3
cmovl P2, P0
cmovl P0, S1
cmp P1, S2
cmovg S2, P1
cmovl P3, P1
cmp P3, P0
cmovl S0, P0
cmovle P0, P3
mov P1, S2
cmovl P3, S0
cmp P1, P2
