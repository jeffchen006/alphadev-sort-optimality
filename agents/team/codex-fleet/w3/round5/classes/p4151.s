# n=5 model=out iset=I1 prefix14_class=4151
cmp P3, P2
cmovge S2, P2
mov S0, P0
cmovle S2, P3
cmovg P2, P3
cmp P1, S0
cmovl P0, P1
cmovge S0, P1
mov S1, S2
cmp P0, S1
cmovl S1, P0
cmovge S2, P0
cmp P2, S0
cmovl P1, S0
