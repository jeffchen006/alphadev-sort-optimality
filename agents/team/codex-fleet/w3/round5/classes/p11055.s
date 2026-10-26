# n=5 model=out iset=I1 prefix14_class=11055
mov S1, P2
cmp P1, S1
cmovle P2, P1
cmovge S1, P1
cmp P0, P3
cmovl S0, P0
cmovle P0, P3
mov P1, P2
cmovl P3, S0
cmp P0, S1
cmovle S0, P0
cmovl P0, S1
cmovl S1, S0
cmp P2, P3
