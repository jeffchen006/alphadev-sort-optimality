# n=5 model=out iset=I1 prefix14_class=5356
cmp P2, P1
cmovge S0, P1
cmovl S0, P2
mov S1, P3
cmovg P1, P2
cmp P0, S1
cmovg P3, P0
cmovle S1, P0
mov S2, P1
cmp S0, S1
cmovle P0, S0
cmovle S0, S1
cmovl S1, P0
cmp P3, S2
