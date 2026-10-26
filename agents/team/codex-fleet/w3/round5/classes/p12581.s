# n=5 model=out iset=I1 prefix14_class=12581
cmp P1, P3
cmovge S0, P1
cmovg P1, P3
cmovl S0, P3
mov S1, P1
cmp P0, P2
cmovl P3, P2
cmovl P2, P0
cmovl P0, P3
cmp P2, S1
cmovle S1, P2
cmovle P2, P1
mov S1, P0
cmp P0, S0
