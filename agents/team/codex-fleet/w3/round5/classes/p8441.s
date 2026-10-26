# n=5 model=out iset=I1 prefix14_class=8441
mov S0, P3
cmp S0, P0
cmovge S0, P0
cmovl P3, P0
cmp P1, P2
cmovle S1, P1
cmovge S1, P2
cmovle P1, P2
cmovl P2, S1
cmp P3, P1
cmovge S2, P1
cmovg P1, P3
cmovg P3, S2
cmp P2, S0
