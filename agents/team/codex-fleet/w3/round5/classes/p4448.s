# n=5 model=out iset=I1 prefix14_class=4448
cmp P3, P2
cmovge S0, P2
cmovge P2, P3
cmovg P3, S0
cmp P0, P1
cmovge S0, P0
cmovle S0, P1
cmovle P1, P0
mov S2, P2
cmp S2, S0
cmovl S2, S0
cmovl S0, P2
cmp P1, P3
cmovge S2, P1
