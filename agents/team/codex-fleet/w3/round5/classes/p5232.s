# n=5 model=out iset=I1 prefix14_class=5232
mov S0, P0
cmp P0, P2
cmovg P0, P2
mov S1, P0
mov S2, P3
cmovl S0, P2
cmp P1, S2
cmovle P3, P1
cmovl P1, S2
cmp P0, P3
cmovle P0, P3
cmovge S1, P3
cmp P1, S0
cmovle S1, P1
