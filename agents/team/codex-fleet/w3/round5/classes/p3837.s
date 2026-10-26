# n=5 model=out iset=I1 prefix14_class=3837
mov S2, P1
cmp S2, P2
cmovge P1, P2
cmovge P2, S2
cmp P0, P3
cmovge S0, P0
cmovl S0, P3
cmovle P3, P0
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
cmp S0, P2
cmovl S1, P2
