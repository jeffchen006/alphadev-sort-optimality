# n=5 model=out iset=I1 prefix14_class=2663
mov S1, P0
cmp P3, P0
cmovl P0, P3
cmovge S1, P3
mov S2, P0
cmp P2, P1
cmovl S0, P2
cmovge S0, P1
cmovg P1, P2
cmp P1, S1
cmovle P2, S1
cmovl S1, P1
cmovl P1, P2
cmp S0, S2
