# n=5 model=out iset=I1 prefix14_class=7348
cmp P3, P2
cmovge S1, P2
cmovge P2, P3
cmovle S1, P3
cmp P0, P1
mov S0, P1
cmovle P1, P0
mov P3, P1
cmovl P0, S0
cmp P1, S1
cmovl P3, S1
cmovl S1, P1
mov S1, P3
cmp P0, P2
