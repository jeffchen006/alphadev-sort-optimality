# n=5 model=out iset=I1 prefix14_class=9259
cmp P1, P0
mov S2, P1
cmovge S2, P0
mov S1, P3
cmovl P1, P0
cmp P2, S1
mov S0, S2
cmovle S1, P2
cmovg P3, P2
cmp S1, S0
cmovl S0, S1
cmovl S1, S2
cmp P1, P3
cmovle S2, P1
