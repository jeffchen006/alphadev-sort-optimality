# n=5 model=out iset=I1 prefix14_class=7343
mov S0, P0
cmp P1, S0
mov S2, P3
cmovg S0, P1
cmovl P0, P1
cmp P2, P3
cmovle S2, P2
mov S1, P0
cmovle P2, P3
cmp S1, S2
cmovl P0, S2
cmovl S2, S1
cmp S0, P2
cmovge S2, S0
