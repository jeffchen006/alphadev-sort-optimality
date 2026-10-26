# n=5 model=out iset=I1 prefix14_class=11101
cmp P1, P0
mov S0, P0
cmovle S0, P1
cmovge P0, P1
cmp P3, P2
mov S1, P3
cmovl P3, P2
cmovle P2, S1
cmp P0, P3
cmovl S2, P3
cmovl P3, P0
cmovl P0, S2
cmp P2, S0
cmovge P1, P2
