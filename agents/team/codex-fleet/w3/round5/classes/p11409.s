# n=5 model=out iset=I1 prefix14_class=11409
cmp P2, P0
cmovle S2, P0
cmovle P0, P2
cmovl P2, S2
cmp P3, P1
cmovge S1, P3
cmovl S1, P1
cmovle P1, P3
mov S0, P1
cmp P0, P1
cmovl S0, P0
cmovle P0, P1
mov P3, P2
cmp P2, S1
