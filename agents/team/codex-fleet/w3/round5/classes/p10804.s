# n=5 model=out iset=I1 prefix14_class=10804
mov S0, P2
cmp P0, P2
cmovle S0, P0
cmovge P2, P0
cmp P3, P1
cmovle S1, P3
cmovle P3, P1
cmovl P1, S1
cmp P3, P2
cmovl S1, P3
cmovle P3, P2
cmovl P2, S1
cmp P1, S0
cmovge S2, P1
