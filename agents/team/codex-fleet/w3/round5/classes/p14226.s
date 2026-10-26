# n=5 model=out iset=I1 prefix14_class=14226
cmp P1, P3
cmovle S0, P3
cmovl P3, P1
cmovl P1, S0
mov S2, P2
cmp P0, P2
cmovg P2, P0
cmovle S2, P0
cmp P1, P2
cmovl S1, P2
mov P0, S2
cmovl P2, P1
cmovl P1, S1
cmp P3, P0
