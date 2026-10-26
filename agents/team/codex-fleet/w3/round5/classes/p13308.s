# n=5 model=out iset=I1 prefix14_class=13308
cmp P3, P1
cmovge S0, P3
cmovl S0, P1
cmovl P1, P3
cmp P0, P2
cmovle S1, P2
cmovl P2, P0
cmovle P0, S1
cmp P1, P2
cmovge S1, P1
cmovge P1, P2
mov S2, S0
cmovge P2, S1
cmp S0, P0
