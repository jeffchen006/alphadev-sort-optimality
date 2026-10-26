# n=5 model=out iset=I1 prefix14_class=1167
cmp P3, P0
cmovle S0, P3
cmovle P3, P0
cmovle P0, S0
cmp P2, P1
cmovl S2, P2
cmovle P2, P1
mov S1, P3
cmovge S2, P1
cmp P3, P2
cmovle S1, P2
cmovge P3, P2
cmp S2, P0
cmovl S1, P0
