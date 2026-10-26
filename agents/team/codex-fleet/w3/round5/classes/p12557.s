# n=5 model=out iset=I1 prefix14_class=12557
cmp P1, P3
mov S1, P1
cmovl P1, P3
mov S2, P2
cmovle P3, S1
cmp P2, P0
cmovg S2, P0
cmovle P2, P0
cmp P3, S2
mov P0, P2
cmovl S0, S2
cmovl S2, P3
cmovl P3, S0
cmp P0, P1
