# n=5 model=out iset=I1 prefix14_class=5848
cmp P0, P2
cmovle S2, P0
cmovle P0, P2
cmovge S2, P2
cmp P1, P3
mov S1, P1
cmovl P1, P3
cmovge S1, P3
cmp S1, S2
cmovle P3, S1
cmovl S1, S2
mov S0, P0
cmovl S2, P3
mov P2, S1
