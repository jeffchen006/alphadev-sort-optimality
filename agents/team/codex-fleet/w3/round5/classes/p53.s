# n=5 model=out iset=I1 prefix14_class=53
mov S2, P2
mov S1, P0
cmp P1, S2
cmovl S2, P1
cmovle P1, P2
mov S0, S2
cmp P3, P0
cmovge P0, P3
cmovl S1, P3
cmp S0, S1
cmovle S2, S1
cmovge S0, S1
mov S1, S2
cmp P1, P0
