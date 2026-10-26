# n=5 model=out iset=I1 prefix14_class=12637
mov S2, P2
cmp S2, P0
mov S1, P3
cmovl P2, P0
cmovge S2, P0
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
cmp S1, S2
cmovl P3, S2
cmovle S2, S1
cmovl S1, P3
mov S0, S1
cmp P2, P1
