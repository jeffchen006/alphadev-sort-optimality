# n=5 model=out iset=I1 prefix14_class=10623
cmp P3, P0
cmovle S2, P0
cmovle P0, P3
mov S0, P2
cmovle P3, S2
cmp P2, P1
cmovg P2, P1
cmovl S0, P1
cmp S0, P3
cmovl S1, P3
cmovle P3, S0
cmovl S0, S1
cmp P2, P0
cmovge S0, P0
