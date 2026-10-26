# n=5 model=out iset=I1 prefix14_class=2348
cmp P1, P3
cmovl S1, P1
cmovl P1, P3
cmovl P3, S1
mov S0, P2
cmp P2, P0
cmovge P2, P0
cmovle S0, P0
cmp P1, S0
cmovg P0, S0
cmovge S0, P1
cmovle P0, P1
cmp P2, P3
cmovl S1, P3
