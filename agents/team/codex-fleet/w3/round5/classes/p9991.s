# n=5 model=out iset=I1 prefix14_class=9991
mov S2, P0
cmp P1, P2
cmovl S1, P1
cmovl P1, P2
cmovge S1, P2
cmp P3, P0
cmovle S2, P3
cmovl P3, P0
mov P2, P3
cmp P1, P2
cmovg P3, P1
cmovg P1, P2
cmp S2, S1
cmovl S0, S2
