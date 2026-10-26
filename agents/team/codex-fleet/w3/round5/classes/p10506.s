# n=5 model=out iset=I1 prefix14_class=10506
mov S2, P0
mov S1, P1
cmp P3, S2
cmovl S2, P3
cmovge P0, P3
cmp P1, P2
cmovge P1, P2
cmovl S1, P2
cmp P0, S1
cmovle S0, P0
cmovl P0, S1
cmovl S1, S0
cmp S2, P1
cmovle P0, S2
