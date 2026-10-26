# n=5 model=out iset=I1 prefix14_class=4150
cmp P3, P2
cmovge S2, P2
cmovge P2, P3
cmovle S2, P3
mov S0, P1
cmp P0, S0
cmovl P1, P0
cmovge S0, P0
mov S1, S2
cmp P1, S1
cmovl S1, P1
cmovge S2, P1
cmp P2, S0
cmovl P0, S0
