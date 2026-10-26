# n=5 model=out iset=I1 prefix14_class=14346
mov S2, P0
cmp P0, P1
cmovle P0, P1
cmovl P1, S2
cmp P2, P3
cmovle S1, P2
cmovl P2, P3
cmovle P3, S1
cmp P3, P1
cmovge S0, P1
cmovl S0, P3
cmovg P1, P3
mov P3, P2
cmp P0, P3
