# n=5 model=out iset=I1 prefix14_class=14103
mov S1, P0
cmp P3, S1
cmovle S1, P3
mov S0, P1
cmovg P0, P3
cmp P2, P1
cmovge S0, P2
cmovle P1, P2
cmp S0, P0
cmovl S2, S0
cmovle S0, P0
cmovl P0, S2
cmp S1, P1
cmovle P3, S1
