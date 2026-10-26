# n=5 model=out iset=I1 prefix14_class=12186
cmp P1, P2
cmovge S0, P2
cmovl S0, P1
cmovle P1, P2
mov S1, P0
cmp P3, P0
cmovge P0, P3
cmovle S1, P3
cmp S1, S0
cmovl S2, S1
cmovle S1, S0
cmovl S0, S2
cmp P1, P0
cmovle S2, P0
