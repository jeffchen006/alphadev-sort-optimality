# n=5 model=out iset=I1 prefix14_class=2375
cmp P2, P1
cmovl S2, P2
mov S1, P3
cmovge S2, P1
cmovg P1, P2
cmp P0, S1
cmovge P3, P0
mov S0, P1
cmovl S1, P0
cmp P1, P3
cmovle P1, P3
cmovle P3, S0
cmp S1, S2
cmovge S0, S1
