# n=5 model=out iset=I1 prefix14_class=12251
cmp P1, P0
cmovge S0, P0
cmovl S0, P1
cmovle P1, P0
cmp P2, P3
mov S2, P3
cmovle S2, P2
cmovge P3, P2
mov S1, S2
cmp S1, S0
cmovle S1, S0
cmovl S0, S2
cmp P1, P3
cmovle S0, P1
