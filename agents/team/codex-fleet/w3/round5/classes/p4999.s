# n=5 model=out iset=I1 prefix14_class=4999
mov S2, P2
cmp P1, P3
cmovl S0, P3
cmovle P3, P1
cmovge S0, P1
cmovle P1, S0
cmp P0, P2
cmovle S2, P0
cmovg P2, P0
cmp S2, P3
cmovle S1, P3
cmovle P3, S2
cmovl S2, S1
cmp P1, P2
