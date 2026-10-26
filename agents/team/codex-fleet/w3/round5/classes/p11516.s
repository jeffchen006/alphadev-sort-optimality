# n=5 model=out iset=I1 prefix14_class=11516
cmp P0, P1
mov S1, P3
cmovle S0, P1
cmovle P1, P0
cmovle P0, S0
cmp P2, P3
cmovl P3, P2
cmovle P2, S1
cmovl S1, P3
cmp P3, P1
cmovl S1, P1
cmovl P1, P3
cmp P2, P0
cmovge P1, P0
