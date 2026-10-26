# n=5 model=out iset=I1 prefix14_class=12178
cmp P2, P1
cmovge S2, P2
cmovle S2, P1
mov S0, P0
cmovg P2, P1
cmp P3, P0
cmovl S0, P3
cmovg P0, P3
cmp S0, P2
cmovle P1, S0
cmovle S0, P2
cmovle P2, P1
cmp S2, P0
cmovle S1, P0
