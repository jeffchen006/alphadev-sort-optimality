# n=5 model=out iset=I1 prefix14_class=14225
cmp P1, P0
cmovle S0, P0
cmovl P0, P1
cmovl P1, S0
mov S2, P2
cmp P3, P2
cmovg P2, P3
cmovle S2, P3
cmp P1, P2
cmovl S1, P2
mov P3, S2
cmovl P2, P1
cmovl P1, S1
cmp P0, P3
