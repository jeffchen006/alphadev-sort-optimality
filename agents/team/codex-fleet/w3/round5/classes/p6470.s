# n=5 model=out iset=I1 prefix14_class=6470
mov S0, P3
cmp P3, P0
mov S1, P1
cmovl S0, P0
cmovl P0, P3
cmp P2, S1
cmovle P1, P2
cmovg S1, P2
cmp S1, S0
cmovle S2, S1
cmovge S2, S0
cmovle S1, S0
cmp P0, P1
cmovl P2, P1
