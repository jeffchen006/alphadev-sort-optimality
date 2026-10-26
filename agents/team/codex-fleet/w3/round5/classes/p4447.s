# n=5 model=out iset=I1 prefix14_class=4447
cmp P3, P1
cmovge S1, P1
cmovge P1, P3
cmovge P3, S1
mov S2, P0
cmp P0, P2
cmovle S2, P2
mov S0, P1
cmovl P2, P0
cmp P1, S2
cmovl P1, S2
cmovl S2, S0
mov P1, S2
mov S0, P3
