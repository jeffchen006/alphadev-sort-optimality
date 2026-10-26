# n=5 model=out iset=I1 prefix14_class=5938
mov S2, P1
cmp P1, P3
cmovge P1, P3
cmovle S2, P3
cmp P2, P0
cmovl S1, P2
cmovge S1, P0
cmovl P2, P0
cmovge P0, P2
cmp P0, S2
cmovge P2, S2
cmovl P0, S2
cmp P1, S1
cmovl S0, S1
