# n=5 model=out iset=I1 prefix14_class=4070
cmp P2, P0
cmovle S0, P2
cmovle P2, P0
cmovle P0, S0
cmp P1, P3
cmovl S2, P3
cmovge S2, P1
cmovl P3, P1
cmp P3, P0
mov S1, S2
mov P1, P3
cmovg P3, P0
cmovle P1, P0
cmp S2, P2
