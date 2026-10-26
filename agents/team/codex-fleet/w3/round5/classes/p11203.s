# n=5 model=out iset=I1 prefix14_class=11203
cmp P0, P1
mov S0, P1
cmovle P1, P0
cmovle P0, S0
mov S1, P2
cmp P2, P3
cmovl S1, P3
cmovle P3, P2
cmp P0, S1
cmovl S2, P0
cmovl P0, S1
cmovge S2, S1
cmp P3, P1
cmovle S0, P1
