# n=5 model=out iset=I1 prefix14_class=9323
cmp P1, P3
mov S2, P1
cmovle P1, P3
cmovl P3, S2
cmp P0, P2
mov S1, P2
cmovle S1, P0
cmovle P0, P2
cmp P3, S1
cmovge S0, S1
cmovl S0, P3
cmovge S1, P3
cmp P0, P1
cmovl P3, P1
