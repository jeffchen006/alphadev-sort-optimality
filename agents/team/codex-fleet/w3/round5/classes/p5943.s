# n=5 model=out iset=I1 prefix14_class=5943
mov S2, P2
cmp P3, P1
cmovge S0, P3
cmovle S0, P1
cmovle P1, P3
cmp P0, S2
cmovge S2, P0
cmovle P2, P0
cmp S2, S0
cmovle P0, S0
cmovl S0, S2
cmovle S2, P0
mov S1, P2
cmp P1, P2
