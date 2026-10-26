# n=5 model=out iset=I1 prefix14_class=6028
cmp P3, P2
mov S2, P2
cmovl P2, P3
cmovl P3, S2
mov S0, P1
cmp P0, P1
cmovle P1, P0
cmovle P0, S0
cmp P0, P3
cmovl S1, P0
cmovge S1, P3
cmovg P3, P0
cmp P2, P1
cmovle P0, P2
