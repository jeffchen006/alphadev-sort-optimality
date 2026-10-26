# n=5 model=out iset=I1 prefix14_class=13610
cmp P2, P1
cmovle S0, P1
cmovle P1, P2
cmovl P2, S0
cmp P3, P0
mov S2, P0
cmovl S2, P3
mov S1, S2
cmovl P3, P0
cmp P1, S2
cmovl S1, P1
cmovge S2, P1
mov S1, P2
cmp S1, P3
