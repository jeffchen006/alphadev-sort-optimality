# n=5 model=out iset=I1 prefix14_class=10674
cmp P3, P0
cmovl S0, P0
cmovl P0, P3
cmovl P3, S0
mov S2, P2
cmp P2, P1
cmovge P2, P1
cmovl S2, P1
cmp P3, S2
cmovle S1, S2
cmovle S2, P3
cmovl P3, S1
cmp P2, P0
cmovle S1, P2
