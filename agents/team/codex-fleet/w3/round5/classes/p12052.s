# n=5 model=out iset=I1 prefix14_class=12052
cmp P3, P1
cmovge S0, P3
cmovle S0, P1
mov S1, P2
cmovl P1, P3
cmp P2, P0
cmovl P2, P0
cmovle P0, S1
cmp P0, P1
cmovl S1, P0
cmovl P0, P1
cmovl P1, S1
mov P1, S0
cmp P2, S0
