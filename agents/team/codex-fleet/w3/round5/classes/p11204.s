# n=5 model=out iset=I1 prefix14_class=11204
cmp P3, P0
cmovl S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P1, P2
mov S0, P1
cmovl P1, P2
cmovl P2, S0
cmp P3, P1
cmovle S0, P3
cmovl P3, P1
mov P3, P0
cmovg S0, P1
cmp P2, P0
