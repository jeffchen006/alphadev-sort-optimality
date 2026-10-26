# n=5 model=out iset=I1 prefix14_class=2548
cmp P0, P1
cmovle S0, P1
cmovle P1, P0
cmovl P0, S0
cmp P3, P2
mov S2, P3
cmovl P3, P2
cmovle P2, S2
cmp P0, P3
cmovl S2, P0
cmovge S2, P3
cmovle P0, P3
mov S1, P1
mov P3, S2
