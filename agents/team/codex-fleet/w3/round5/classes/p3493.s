# n=5 model=out iset=I1 prefix14_class=3493
cmp P3, P1
cmovle S2, P3
cmovg S2, P1
cmovl P3, P1
cmp P2, P0
cmovl S1, P2
cmovge S1, P0
cmovl P2, P0
mov S0, S1
cmp S2, S0
cmovg S0, S2
cmovg S2, S1
cmp P2, P3
cmovle P0, P2
