# n=5 model=out iset=I1 prefix14_class=14142
cmp P3, P0
cmovle S2, P0
mov S0, P1
cmovl P0, P3
cmovle P3, S2
cmp P2, P1
cmovg S0, P2
cmovg P2, P1
cmp P3, S0
cmovl S1, S0
cmovge S1, P3
cmovl S0, P3
cmp P2, P0
cmovge S1, P0
