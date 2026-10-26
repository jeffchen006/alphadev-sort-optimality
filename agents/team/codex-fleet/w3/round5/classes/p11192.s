# n=5 model=out iset=I1 prefix14_class=11192
cmp P1, P2
cmovge S0, P2
cmovg P2, P1
cmovg P1, S0
cmp P3, P0
cmovl S1, P3
cmovl P3, P0
cmovl P0, S1
mov S0, P3
cmp S0, P2
cmovl P3, P2
mov P3, P1
cmovge S0, P2
cmp P1, P0
