# n=5 model=out iset=I1 prefix14_class=11902
cmp P0, P3
mov S2, P1
cmovle S1, P0
cmovl P0, P3
cmovle P3, S1
cmp S2, P2
cmovle S2, P2
mov S0, S2
cmovl P2, P1
cmp S0, P0
cmovge S2, P0
cmovg P0, S0
cmp P3, P2
cmovge S1, P2
