# n=5 model=out iset=I1 prefix14_class=3581
mov S0, P1
cmp P1, P3
cmovle P1, P3
cmovl P3, S0
cmp P0, P2
cmovl S2, P2
cmovl P2, P0
mov S0, P3
cmovge S2, P0
cmp P2, P3
cmovl S0, P2
cmovg P3, P2
mov S0, S2
cmp S2, P1
