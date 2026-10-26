# n=5 model=out iset=I1 prefix14_class=2869
cmp P3, P1
cmovge S1, P3
cmovle S1, P1
cmovle P1, P3
cmp P0, P2
mov S0, P0
cmovg P0, P2
cmovle S0, P2
cmp S1, S0
cmovl S2, S0
cmovle S0, S1
cmovge S2, S1
cmp P1, P0
cmovl S2, P1
