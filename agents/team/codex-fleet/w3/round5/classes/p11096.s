# n=5 model=out iset=I1 prefix14_class=11096
mov S0, P0
cmp P1, P0
cmovl S0, P1
cmovge P0, P1
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovle P2, S1
cmp P0, P3
cmovl P1, P3
cmovl P3, P0
cmovl P0, P1
cmp P2, S0
cmovle S2, S0
