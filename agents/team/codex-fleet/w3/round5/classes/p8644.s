# n=5 model=out iset=I1 prefix14_class=8644
mov S2, P2
cmp P2, P3
mov S0, P1
cmovl P2, P3
cmovge S2, P3
cmp P0, S0
cmovl P1, P0
cmovl P0, S0
cmovge S0, P0
cmp P2, P0
cmovle P0, P2
cmovge S0, P2
cmp S2, P1
cmovle S0, S2
