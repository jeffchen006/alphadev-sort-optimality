# n=5 model=out iset=I1 prefix14_class=7347
mov S0, P0
mov S2, P3
cmp P2, S0
cmovl S0, P2
cmovge P0, P2
cmp P1, S2
cmovle S2, P1
cmovl P1, P3
cmp S2, S0
cmovle P2, S2
cmovl S2, S0
mov S1, P1
cmovl S0, P2
cmp P1, P0
