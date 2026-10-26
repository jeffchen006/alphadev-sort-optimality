# n=5 model=out iset=I1 prefix14_class=13284
cmp P2, P0
cmovl S2, P0
cmovl P0, P2
mov S0, P0
cmovl P2, S2
cmp P3, P1
cmovle S1, P3
cmovg S1, P1
cmovle P3, P1
cmp P0, S1
cmovge S0, S1
cmovl P0, S1
cmp P3, P2
cmovle S2, P3
