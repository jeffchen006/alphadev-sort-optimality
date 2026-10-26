# n=5 model=out iset=I1 prefix14_class=11983
mov S2, P1
cmp P2, P3
cmovle S1, P2
cmovl P2, P3
cmovge S1, P3
cmp S2, P0
cmovle P1, P0
cmovle P0, S2
cmp P0, S1
cmovle S0, S1
cmovl S1, P0
cmovle P0, S0
cmp P2, P1
cmovle S0, P2
