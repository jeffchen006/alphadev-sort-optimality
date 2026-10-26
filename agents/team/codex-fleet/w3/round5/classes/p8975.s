# n=5 model=out iset=I1 prefix14_class=8975
mov S0, P3
cmp P3, P0
cmovle S0, P0
cmovl P0, P3
cmp P1, P2
cmovle S2, P1
mov S1, S0
cmovl P1, P2
cmovle P2, S2
cmp P1, S0
cmovge S0, P1
cmovl S1, P1
mov P1, P2
cmp P1, P0
