# n=5 model=out iset=I1 prefix14_class=8064
cmp P3, P0
cmovle S0, P0
mov S1, P2
cmovle P0, P3
cmovle P3, S0
cmp S1, P1
cmovge S1, P1
mov S2, P0
cmovg P1, P2
cmp S1, P0
cmovl S2, S1
cmovl S1, P0
mov S2, P3
cmp S2, P1
