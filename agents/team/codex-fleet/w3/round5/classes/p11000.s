# n=5 model=out iset=I1 prefix14_class=11000
mov S1, P1
cmp P1, P0
cmovl S1, P0
cmovg P1, P0
cmp P3, P2
cmovle S2, P3
mov S0, S1
cmovl P3, P2
cmovle P2, S2
cmp P3, S0
cmovl S0, P3
cmovge S1, P3
cmp P1, P2
cmovle P3, P2
