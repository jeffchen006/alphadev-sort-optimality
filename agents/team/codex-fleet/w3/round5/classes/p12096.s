# n=5 model=out iset=I1 prefix14_class=12096
mov S0, P0
cmp P2, P0
mov S1, P1
cmovg P0, P2
cmovg P2, S0
cmp P3, S1
cmovl S1, P3
cmovl P3, P1
cmp S1, P2
cmovle P1, P2
cmovl P2, S1
cmovl S1, P1
cmp P0, P3
cmovge S0, P3
