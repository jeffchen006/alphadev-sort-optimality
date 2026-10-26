# n=5 model=out iset=I1 prefix14_class=7477
cmp P1, P3
cmovl S1, P1
cmovge S1, P3
cmovl P1, P3
cmp P0, P2
mov P3, P2
cmovle P3, P0
cmovle P0, P2
cmp P3, S1
cmovle S0, P3
cmovle P3, S1
cmovl S1, S0
cmp P0, P1
cmovg P2, P1
