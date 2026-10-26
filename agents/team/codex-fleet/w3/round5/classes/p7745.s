# n=5 model=out iset=I1 prefix14_class=7745
cmp P1, P2
cmovl S1, P2
mov S2, P3
cmovl P2, P1
cmovge S1, P1
mov S0, P2
cmp P0, P3
cmovle S2, P0
cmovg P3, P0
cmp S0, S2
cmovge P2, S2
cmovl S0, S2
cmp S1, P3
cmovle P1, S1
