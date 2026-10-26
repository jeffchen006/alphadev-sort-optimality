# n=5 model=out iset=I1 prefix14_class=7114
cmp P3, P2
cmovle S2, P2
cmovle P2, P3
mov S0, P0
cmovle P3, S2
cmp S0, P1
cmovl P0, P1
cmovle P1, S0
cmp P1, P2
cmovge S1, P1
cmovg P1, P2
cmovl S1, P2
cmp P3, P0
mov P2, P0
