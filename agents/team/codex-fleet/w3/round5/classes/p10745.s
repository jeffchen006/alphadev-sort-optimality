# n=5 model=out iset=I1 prefix14_class=10745
mov S0, P0
cmp P3, P0
cmovge S0, P3
cmovl P0, P3
mov P3, S0
cmp P2, P1
cmovle S1, P2
cmovle P2, P1
cmovle P1, S1
cmp P3, P2
cmovl S0, P2
cmovle P2, P3
cmp P1, P0
cmovge S1, P0
