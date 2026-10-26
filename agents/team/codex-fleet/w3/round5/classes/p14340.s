# n=5 model=out iset=I1 prefix14_class=14340
mov S0, P2
cmp P1, S0
cmovle S0, P1
cmovl P1, P2
cmovl P2, S0
cmp P3, P0
cmovl S2, P3
cmovl P3, P0
cmovl P0, S2
cmp P0, P2
cmovge S0, P0
cmovge P0, P2
mov P0, P1
cmp P3, P0
