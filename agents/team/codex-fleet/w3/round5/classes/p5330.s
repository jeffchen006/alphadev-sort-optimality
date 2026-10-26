# n=5 model=out iset=I1 prefix14_class=5330
cmp P2, P3
mov S1, P3
cmovge P3, P2
mov S0, P1
cmovl S1, P2
cmp S0, P0
cmovge P1, P0
cmovle S0, P0
cmp S1, P1
cmovge S2, S1
cmovl S2, P1
cmovle P1, S1
cmp P3, S0
cmovle S1, S0
