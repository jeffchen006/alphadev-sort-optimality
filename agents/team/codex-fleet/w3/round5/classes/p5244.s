# n=5 model=out iset=I1 prefix14_class=5244
mov S0, P2
cmp P2, P3
cmovg P2, P3
cmovg P3, S0
cmp P1, P0
cmovl S1, P0
cmovl P0, P1
cmovl P1, S1
cmp P2, P0
cmovge S2, P0
cmovle S2, P2
cmovge P0, P2
cmp P1, P3
cmovle S0, P3
