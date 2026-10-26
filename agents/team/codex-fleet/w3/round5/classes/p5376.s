# n=5 model=out iset=I1 prefix14_class=5376
cmp P1, P3
mov S0, P0
cmovl S2, P3
cmovle P3, P1
cmovl P1, S2
mov S1, P3
cmp P2, S0
cmovl P0, P2
cmovle P2, S0
cmp P0, P3
cmovle P3, P0
mov P3, P1
cmovg S1, P0
cmp P1, P2
