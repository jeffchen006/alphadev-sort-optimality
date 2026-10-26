# n=5 model=out iset=I1 prefix14_class=14416
mov S1, P0
cmp P1, S1
cmovl P0, P1
cmovl P1, S1
mov S0, P3
cmp P3, P2
cmovl S0, P2
cmovle P2, P3
cmp P0, P2
cmovg P3, P0
cmovg P0, P2
cmovg P2, P3
cmp P1, S0
cmovge S2, P1
