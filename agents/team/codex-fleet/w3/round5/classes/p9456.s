# n=5 model=out iset=I1 prefix14_class=9456
cmp P0, P1
cmovl S2, P0
cmovl P0, P1
cmovl P1, S2
cmp P3, P2
cmovge S0, P2
cmovle S0, P3
cmovl P3, P2
mov S1, P1
cmp S0, S1
cmovg P1, S0
cmovle S1, S0
mov S1, P3
cmovle S0, P1
