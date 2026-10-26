# n=5 model=out iset=I1 prefix14_class=2356
cmp P3, P0
cmovl S0, P3
cmovle P3, P0
cmovl P0, S0
cmp P1, P2
cmovge S1, P1
cmovl S1, P2
cmovg P1, P2
cmp P3, S1
mov S2, S1
cmovge S2, P3
cmovle S1, P3
cmp P1, P0
mov P3, S1
