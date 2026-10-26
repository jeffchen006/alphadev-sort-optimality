# n=5 model=out iset=I1 prefix14_class=4374
mov S2, P2
cmp P0, P2
cmovl S2, P0
cmovl P0, P2
cmp P3, P1
cmovle S0, P3
cmovl P3, P1
cmovl P1, S0
cmp P1, S2
cmovge P2, P1
cmovl P2, S2
cmovge P1, S2
cmp P0, P3
mov P1, P2
