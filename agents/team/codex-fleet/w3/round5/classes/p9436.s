# n=5 model=out iset=I1 prefix14_class=9436
mov S1, P0
cmp P2, S1
cmovl P0, P2
cmovle P2, S1
cmp P3, P1
cmovle S0, P3
cmovl P3, P1
cmovl P1, S0
cmp P0, P1
cmovge S2, P0
cmovl S2, P1
mov S1, P3
cmovl P1, P0
mov P1, S2
