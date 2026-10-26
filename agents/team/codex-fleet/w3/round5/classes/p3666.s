# n=5 model=out iset=I1 prefix14_class=3666
cmp P2, P0
cmovg S2, P2
cmovle S2, P0
cmovl P0, P2
cmp P1, P3
cmovle S0, P1
cmovle P1, P3
cmovl P3, S0
cmp P3, P0
mov P2, S2
mov S1, P3
cmovl S1, P0
cmovl P0, P3
cmp P1, S2
