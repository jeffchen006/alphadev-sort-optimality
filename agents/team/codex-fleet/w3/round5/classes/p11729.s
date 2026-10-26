# n=5 model=out iset=I1 prefix14_class=11729
cmp P2, P0
cmovl S1, P0
cmovge S1, P2
cmovl P0, P2
mov S2, P3
cmp S2, P1
cmovge S2, P1
cmovg P1, P3
cmp S1, P1
mov P3, S2
cmovle S0, S1
cmovle S1, P1
cmovl P1, S0
mov S1, P1
