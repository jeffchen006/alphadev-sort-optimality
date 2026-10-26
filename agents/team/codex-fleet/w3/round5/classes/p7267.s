# n=5 model=out iset=I1 prefix14_class=7267
cmp P2, P1
cmovl S2, P2
mov S0, P3
cmovl P2, P1
cmovl P1, S2
cmp P0, S0
cmovle S0, P0
cmovle P0, P3
cmp P1, S0
mov P3, S0
cmovle P3, P1
cmovge S0, P1
mov P3, P0
cmp P2, P0
