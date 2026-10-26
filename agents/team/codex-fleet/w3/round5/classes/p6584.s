# n=5 model=out iset=I1 prefix14_class=6584
mov S1, P0
cmp P3, P0
cmovl P0, P3
cmovge S1, P3
cmp P1, P2
cmovle S0, P1
cmovg S0, P2
cmovl P1, P2
cmovl P2, S0
cmp S1, P1
cmovl S2, S1
cmovle S1, P1
cmovl P1, S2
cmp P0, P2
