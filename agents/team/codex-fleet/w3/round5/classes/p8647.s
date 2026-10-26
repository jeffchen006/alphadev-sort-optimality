# n=5 model=out iset=I1 prefix14_class=8647
cmp P2, P3
cmovge S0, P3
cmovl S0, P2
cmovle P2, P3
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmovl P0, S1
mov S2, P0
cmp P2, P0
cmovle S2, P2
cmovge P0, P2
cmp S0, P1
cmovl S1, S0
