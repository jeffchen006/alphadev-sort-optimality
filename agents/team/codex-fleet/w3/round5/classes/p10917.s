# n=5 model=out iset=I1 prefix14_class=10917
mov S0, P1
cmp P2, S0
cmovl P1, P2
cmovge S0, P2
mov P2, P0
cmp P2, P3
cmovle P2, P3
cmovl P3, P0
cmp P2, S0
cmovle S1, P2
cmovle P2, S0
cmovl S0, S1
cmp P1, P3
cmovle S1, P3
