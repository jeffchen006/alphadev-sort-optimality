# n=5 model=out iset=I1 prefix14_class=13514
cmp P3, P1
cmovge S0, P3
cmovle S0, P1
cmovg P3, P1
cmp P2, P0
mov S1, S0
cmovl S2, P0
cmovge S2, P2
cmovle P0, P2
cmp P0, P3
cmovl P2, P3
cmovl P3, P0
cmovl P0, P2
cmp S2, S0
