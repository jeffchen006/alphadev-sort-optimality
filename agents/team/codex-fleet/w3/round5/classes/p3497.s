# n=5 model=out iset=I1 prefix14_class=3497
cmp P1, P0
cmovle S2, P1
cmovl P1, P0
cmovg S2, P0
cmp P3, P2
cmovl S1, P3
cmovge S1, P2
cmovl P3, P2
mov S0, S1
cmp S2, S0
cmovg S0, S2
cmovg S2, S1
cmp P1, P3
cmovl P2, P1
