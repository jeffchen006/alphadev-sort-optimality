# n=5 model=out iset=I1 prefix14_class=9358
cmp P0, P3
mov S2, P3
cmovl S2, P0
cmovle P0, P3
mov S0, P2
cmp P1, P2
cmovle S0, P1
cmovle P1, P2
cmp S0, S2
cmovge S1, S2
cmovge S2, S0
cmovge S0, S1
cmp P1, P0
cmovl P2, P0
