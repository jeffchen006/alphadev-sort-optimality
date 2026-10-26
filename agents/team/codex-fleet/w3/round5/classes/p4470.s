# n=5 model=out iset=I1 prefix14_class=4470
cmp P3, P0
cmovge S1, P0
cmovle S1, P3
mov S0, P2
cmovl P3, P0
cmp P2, P1
cmovl S0, P1
cmovl P1, P2
cmp P3, S0
cmovge S2, S0
cmovl S2, P3
cmovge S0, P3
cmp P1, S1
cmovge P2, P1
