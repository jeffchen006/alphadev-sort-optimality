# n=5 model=out iset=I1 prefix14_class=5783
mov S1, P3
cmp S1, P0
cmovle S1, P0
cmovge P3, P0
mov S2, P2
cmp P1, P2
cmovge P2, P1
cmovl S2, P1
cmp S2, P3
cmovge S0, S2
cmovl S0, P3
cmovle P3, S2
cmp S1, P2
cmovge S2, S0
