# n=5 model=out iset=I1 prefix14_class=8261
cmp P0, P3
cmovle S1, P3
cmovl P3, P0
cmovle P0, S1
cmp P1, P2
cmovl S0, P2
cmovl P2, P1
cmovge S0, P1
cmovge P1, P2
cmp P1, P3
cmovg P2, P3
mov P2, S0
cmovge P3, P1
cmp P0, P2
