# n=5 model=out iset=I1 prefix14_class=721
cmp P3, P2
cmovl S0, P3
mov S2, P1
cmovge S0, P2
cmovle P3, P2
cmp S2, P0
cmovge P1, P0
cmovle S2, P0
cmp P3, S2
cmovle S1, P3
cmovl P3, S2
cmovle S2, S1
cmp S0, P1
cmovge P0, S0
