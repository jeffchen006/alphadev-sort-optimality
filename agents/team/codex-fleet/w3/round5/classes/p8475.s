# n=5 model=out iset=I1 prefix14_class=8475
mov S1, P1
mov S0, P2
cmp P2, P0
cmovge S0, P0
cmovl P2, P0
cmp P1, P3
cmovle S1, P3
cmovle P3, P1
cmp S1, P2
cmovle S2, P2
cmovle P2, S1
cmovl S1, S2
mov S1, P2
cmp P3, S0
