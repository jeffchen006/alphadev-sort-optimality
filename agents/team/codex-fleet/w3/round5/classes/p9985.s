# n=5 model=out iset=I1 prefix14_class=9985
cmp P3, P2
cmovle S2, P2
cmovl P2, P3
mov S1, P1
cmovge S2, P3
cmp S1, P0
cmovle S1, P0
cmovl P0, P1
cmp S1, S2
cmovl P3, S2
mov P1, P0
cmovl S2, S1
cmovl S1, P3
mov S1, S2
