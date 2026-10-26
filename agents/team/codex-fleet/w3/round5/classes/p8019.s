# n=5 model=out iset=I1 prefix14_class=8019
cmp P3, P0
mov S0, P2
cmovle S2, P3
cmovle P3, P0
cmovge S2, P0
cmp P2, P1
cmovge S0, P1
cmovle P2, P1
cmp S2, S0
cmovl S1, S0
cmovge S1, S2
cmovl S0, S2
cmp P2, P3
cmovle S0, P2
