# n=5 model=out iset=I1 prefix14_class=5478
mov S1, P2
cmp P3, P0
cmovl S0, P3
cmovge S0, P0
cmovle P3, P0
cmp P2, P1
cmovge S1, P1
cmovl P2, P1
cmp S1, S0
mov S2, S1
cmovge S1, S0
cmovle S2, S0
cmp P3, P2
cmovge P1, P2
