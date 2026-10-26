# n=5 model=out iset=I1 prefix14_class=10676
cmp P3, P2
mov S0, P2
cmovle P2, P3
cmovl P3, S0
mov S2, P0
cmp P0, P1
cmovge P0, P1
cmovl S2, P1
cmp P3, S2
cmovle S1, S2
cmovle S2, P3
cmovl P3, S1
cmp P0, P2
cmovl S1, P0
