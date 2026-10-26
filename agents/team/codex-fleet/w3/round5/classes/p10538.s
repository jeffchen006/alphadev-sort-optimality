# n=5 model=out iset=I1 prefix14_class=10538
cmp P0, P2
cmovl S0, P0
cmovle P0, P2
cmovl P2, S0
mov S1, P1
cmp P3, P1
cmovge P1, P3
cmovge P3, S1
mov S1, P3
cmp P1, P0
cmovle S2, P1
cmovl P1, P0
cmovl P0, S2
cmp P2, P3
