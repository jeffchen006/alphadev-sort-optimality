# n=5 model=out iset=I1 prefix14_class=12593
cmp P2, P0
cmovle S2, P0
cmovge S2, P2
mov S0, P1
cmovle P0, P2
cmp P3, P1
cmovl S0, P3
cmovl P3, P1
mov S1, S0
cmp P0, S1
cmovle S0, P0
cmovl P0, S1
mov S1, P3
mov S0, P0
