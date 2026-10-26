# n=5 model=out iset=I1 prefix14_class=14447
cmp P0, P3
cmovge S2, P3
mov S0, P1
cmovl S2, P0
cmovge P3, P0
cmp S0, P2
cmovge S0, P2
cmovl P1, P2
cmp S0, S2
cmovle P2, S0
cmovl S0, S2
cmovle S2, P2
cmp P3, P1
cmovge S2, P1
