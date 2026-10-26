# n=5 model=out iset=I1 prefix14_class=12455
cmp P2, P1
cmovl S2, P2
mov S1, P3
cmovl P2, P1
cmovl P1, S2
cmp S1, P0
cmovge S1, P0
cmovl P3, P0
cmp P1, S1
cmovg S0, P1
cmovle S0, S1
cmovle S1, P1
cmp P3, P2
cmovg S1, P3
