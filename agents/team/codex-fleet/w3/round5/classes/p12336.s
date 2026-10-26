# n=5 model=out iset=I1 prefix14_class=12336
mov S0, P2
mov S1, P1
cmp S0, P3
cmovg S0, P3
cmovl P2, P3
cmp P0, P1
cmovge S1, P0
cmovg P0, P1
cmp P0, S0
cmovl P1, S0
cmovl S0, P0
cmovl P0, P1
cmp S1, P2
cmovge P1, S1
