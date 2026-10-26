# n=5 model=out iset=I1 prefix14_class=8545
cmp P1, P3
cmovl S2, P1
cmovle P1, P3
cmovl P3, S2
mov S1, P2
cmp P0, P2
cmovl P2, P0
cmovge S1, P0
cmovl P0, S1
cmp P1, S1
cmovg P0, P1
cmovle S1, P1
mov P1, P2
cmp P3, P1
