# n=5 model=out iset=I1 prefix14_class=8952
cmp P1, P3
cmovle S1, P3
cmovge S1, P1
cmovge P1, P3
cmp P2, P0
cmovle S0, P2
cmovl P2, P0
cmovl P0, S0
cmp P2, S1
mov S2, P2
cmovge P2, S1
cmovl S2, S1
cmp P1, P0
mov S1, P1
