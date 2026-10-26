# n=5 model=out iset=I1 prefix14_class=12031
mov S1, P1
cmp S1, P2
mov S0, P3
cmovl P1, P2
cmovge S1, P2
cmp P0, P3
cmovl P3, P0
cmovl P0, S0
cmp P3, S1
cmovl S2, S1
cmovle S1, P3
cmovl P3, S2
cmp P0, P1
cmovg S0, P1
