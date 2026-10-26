# n=5 model=out iset=I1 prefix14_class=10915
mov S0, P1
cmp P0, S0
cmovl P1, P0
cmovge S0, P0
mov P0, P3
cmp P0, P2
cmovle P0, P2
cmovl P2, P3
cmp P0, S0
cmovle S1, P0
cmovle P0, S0
cmovl S0, S1
cmp P1, P2
cmovle S1, P2
