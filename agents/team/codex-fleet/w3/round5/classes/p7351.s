# n=5 model=out iset=I1 prefix14_class=7351
cmp P3, P0
cmovge S2, P0
cmovg P0, P3
cmovle S2, P3
cmp P1, P2
cmovl S0, P2
cmovle P2, P1
mov P3, P2
cmovl P1, S0
cmp P3, S2
cmovl P2, S2
cmovl S2, P3
mov S1, P1
cmp P1, P0
