# n=5 model=out iset=I1 prefix14_class=8282
cmp P3, P1
mov S1, P1
cmovge S1, P3
mov S0, P0
cmovl P1, P3
cmp P2, S0
cmovg P0, P2
cmovl S0, P2
cmp P1, S0
cmovg P2, P1
cmovg P1, S0
cmovle P2, S0
cmp P0, S1
cmovge S2, S1
