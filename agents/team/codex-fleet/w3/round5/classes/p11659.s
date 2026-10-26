# n=5 model=out iset=I1 prefix14_class=11659
cmp P1, P3
cmovle S2, P3
cmovle P3, P1
mov S1, P0
cmovle P1, S2
cmp P2, P0
cmovl S1, P2
cmovle P2, P0
mov P0, P1
cmp P2, P0
cmovl P0, P2
cmovge P1, P2
cmp S1, P3
cmovge S0, P3
