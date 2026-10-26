# n=5 model=out iset=I1 prefix14_class=10499
cmp P0, P3
cmovle S2, P0
cmovg S2, P3
cmovl P0, P3
cmp P2, P1
cmovl S1, P2
cmovl P2, P1
cmovge S1, P1
cmp P2, P0
cmovl P1, P2
mov S0, S2
cmovl P2, P0
cmovl P0, P1
cmp S0, S1
