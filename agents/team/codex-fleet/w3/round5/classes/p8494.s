# n=5 model=out iset=I1 prefix14_class=8494
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
cmovge S1, P3
cmp P2, P0
cmovle S0, P2
cmovle P2, P0
mov P3, P1
cmovl P0, S0
cmp P3, P2
cmovl P1, P2
cmovg P3, P2
cmp S1, P0
cmovl S2, P0
