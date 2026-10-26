# n=5 model=out iset=I1 prefix14_class=11150
cmp P3, P1
mov S2, P0
cmovle S1, P3
cmovle P3, P1
cmovle P1, S1
cmp S2, P2
cmovle P0, P2
cmovge S2, P2
mov P2, P3
cmp P0, P2
cmovl P3, P0
cmovl P0, P2
cmp S2, P1
cmovl S1, S2
