# n=5 model=out iset=I1 prefix14_class=13123
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmovge S1, P1
cmp P3, P2
cmovle P1, P2
cmovg P1, P3
mov S0, P1
cmovg P3, P2
cmp P3, S1
cmovle S2, P3
cmovle P3, S1
cmovl S1, S2
cmp S0, P0
