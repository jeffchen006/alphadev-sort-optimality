# n=5 model=out iset=I1 prefix14_class=12729
mov S1, P2
cmp S1, P3
cmovl P2, P3
cmovge S1, P3
cmp P1, P0
cmovle S2, P1
cmovle P1, P0
mov S0, S1
cmovl P0, S2
cmp P0, S0
cmovge S1, P0
cmovg P0, S0
cmp P1, P2
cmovge S0, P1
