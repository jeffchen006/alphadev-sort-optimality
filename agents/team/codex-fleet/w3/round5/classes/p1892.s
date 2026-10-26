# n=5 model=out iset=I1 prefix14_class=1892
mov S1, P2
cmp P1, P0
cmovle S2, P0
cmovl P0, P1
cmovl P1, S2
cmp P3, P2
cmovle P2, P3
mov S2, P1
cmovge S1, P3
cmp S1, S2
cmovl S2, S1
cmovle S1, P1
cmp P0, P2
cmovge S0, P0
