# n=5 model=out iset=I1 prefix14_class=6560
cmp P2, P3
mov S1, P0
cmovle S2, P3
cmovge S2, P2
cmovg P2, P3
cmp S1, P1
cmovle S1, P1
cmovle P1, P0
cmp S1, S2
cmovle P3, S2
cmovl S2, S1
cmovl S1, P3
cmp P2, P1
cmovl S0, P2
