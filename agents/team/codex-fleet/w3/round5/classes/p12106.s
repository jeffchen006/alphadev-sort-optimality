# n=5 model=out iset=I1 prefix14_class=12106
cmp P1, P0
cmovle S0, P1
mov S1, P3
cmovl P1, P0
cmovg S0, P0
cmp P2, P3
cmovl S1, P2
mov S2, S0
cmovle P2, P3
cmp S0, S1
cmovg S2, S1
cmovle S0, S1
cmp P1, P2
cmovge S1, P1
