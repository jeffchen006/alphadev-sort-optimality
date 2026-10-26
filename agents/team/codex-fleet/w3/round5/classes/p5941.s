# n=5 model=out iset=I1 prefix14_class=5941
cmp P2, P3
cmovge S0, P2
cmovl S0, P3
cmovle P3, P2
mov S2, P1
cmp P0, S2
cmovge P1, P0
cmovl S2, P0
cmp P1, S0
mov S1, S2
cmovl P0, S0
cmovle S0, P1
cmovl P1, P0
cmp P3, S2
