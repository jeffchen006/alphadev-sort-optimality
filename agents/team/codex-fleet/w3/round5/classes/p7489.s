# n=5 model=out iset=I1 prefix14_class=7489
mov S1, P1
cmp S1, P2
mov S0, P0
cmovge S1, P2
mov S2, S1
cmovl P1, P2
cmp P0, P3
cmovge S0, P3
cmovl P0, P3
cmp S0, S2
cmovle S1, S0
cmovge S2, S0
cmp P0, P1
cmovl P2, P1
