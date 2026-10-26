# n=5 model=out iset=I1 prefix14_class=10427
cmp P2, P1
cmovle S1, P1
cmovg S1, P2
mov S0, P0
cmovl P1, P2
cmp P3, P0
cmovle P0, P3
cmovl P3, S0
cmp P3, S1
mov P2, P0
cmovle S2, P3
cmovl P3, S1
cmovl S1, S2
cmp P1, P2
