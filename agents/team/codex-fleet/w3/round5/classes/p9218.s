# n=5 model=out iset=I1 prefix14_class=9218
mov S1, P0
cmp P3, S1
cmovg P0, P3
cmovg P3, S1
cmp P1, P2
cmovge S0, P1
cmovl S0, P2
cmovl P2, P1
cmp P3, P2
mov S2, P2
cmovl S2, P3
cmovle P3, P0
cmovg P2, P3
cmp P0, S0
