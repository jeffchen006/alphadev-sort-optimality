# n=5 model=out iset=I1 prefix14_class=12362
cmp P1, P3
cmovle S2, P3
cmovle P3, P1
cmovl P1, S2
mov S0, P3
cmp P2, P0
cmovge S1, P2
cmovg P2, P0
cmovl S1, P0
cmp P3, P2
cmovl S0, P2
cmovle P2, P3
mov P2, S1
cmp S1, P1
