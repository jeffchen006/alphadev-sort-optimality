# n=5 model=out iset=I1 prefix14_class=11086
mov S0, P2
cmp P1, P2
cmovle P2, P1
cmovge S0, P1
cmp P0, P3
cmovle S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P0, S0
cmovle S2, S0
cmovl S0, P0
cmovl P0, S2
cmp P3, P2
cmovge S1, P3
