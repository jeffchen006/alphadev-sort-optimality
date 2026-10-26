# n=5 model=out iset=I1 prefix14_class=4663
mov S1, P0
cmp P3, P2
cmovge S0, P2
cmovg P2, P3
cmovg P3, S0
cmp P1, S1
cmovl P0, P1
cmovle P1, S1
cmovge S1, P1
cmp P1, P2
cmovl S1, P2
cmovg P1, P2
cmp P3, P0
cmovge S2, P3
