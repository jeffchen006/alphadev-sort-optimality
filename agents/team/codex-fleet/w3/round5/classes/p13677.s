# n=5 model=out iset=I1 prefix14_class=13677
cmp P3, P0
cmovl S2, P0
cmovl P0, P3
cmovl P3, S2
mov S1, P1
cmp P2, S1
cmovg P1, P2
cmovg P2, S1
mov S0, P1
cmp P3, P1
cmovge S0, P3
cmovg P3, P1
cmp P0, P2
cmovle P1, P3
