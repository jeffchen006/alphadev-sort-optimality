# n=5 model=out iset=I1 prefix14_class=11141
cmp P3, P1
cmovl S1, P3
cmovl P3, P1
cmovl P1, S1
cmp P2, P0
mov S0, P2
cmovle P2, P0
cmovge S0, P0
cmp P3, P2
cmovle S1, P3
cmovl P3, P2
mov P3, P1
cmovl P2, S1
mov P0, P2
