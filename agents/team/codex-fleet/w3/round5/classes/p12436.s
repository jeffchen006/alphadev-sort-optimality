# n=5 model=out iset=I1 prefix14_class=12436
mov S0, P0
cmp S0, P3
cmovle S0, P3
cmovle P3, P0
cmp P1, P2
cmovge S2, P2
cmovle S2, P1
cmovl P1, P2
cmp P3, S2
cmovle P2, S2
cmovl S2, P3
cmovle P3, P2
cmp P1, S0
cmovl S2, P1
