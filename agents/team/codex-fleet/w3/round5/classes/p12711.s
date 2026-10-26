# n=5 model=out iset=I1 prefix14_class=12711
cmp P3, P0
cmovge S1, P0
cmovg P0, P3
cmovg P3, S1
cmp P2, P1
cmovl S1, P2
cmovle P2, P1
cmovl P1, S1
cmp P1, P3
cmovge S2, P3
cmovg P3, P1
mov S0, P0
cmovg P1, S2
cmp P0, P2
