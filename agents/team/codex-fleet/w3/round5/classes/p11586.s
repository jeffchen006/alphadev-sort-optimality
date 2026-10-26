# n=5 model=out iset=I1 prefix14_class=11586
cmp P3, P0
cmovge S2, P3
cmovl S2, P0
mov S0, P2
cmovl P0, P3
cmp S0, P1
cmovge P2, P1
cmovle S0, P1
cmp P0, P2
cmovl S1, P2
cmovle P2, P0
cmovge S1, P0
cmp S2, S0
cmovle P0, S1
