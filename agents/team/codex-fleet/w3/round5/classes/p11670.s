# n=5 model=out iset=I1 prefix14_class=11670
mov S0, P1
cmp P1, P3
cmovl S0, P3
cmovg P1, P3
cmp P0, P2
cmovl P3, P2
mov S1, S0
cmovle P2, P0
cmovl P0, P3
cmp P0, S0
mov S2, P2
cmovge S1, P0
cmovle S0, P0
cmp P1, P2
