# n=5 model=out iset=I1 prefix14_class=4348
cmp P1, P3
cmovl S0, P1
cmovl P1, P3
cmovge S0, P3
cmp P0, P2
cmovle P3, P2
cmovle P2, P0
cmovl P0, P3
cmp S0, P2
mov S2, S0
cmovle S0, P2
cmovle P2, S2
cmp P1, P0
cmovle P3, P0
