# n=5 model=out iset=I1 prefix14_class=2221
cmp P3, P0
mov S2, P2
cmovge S0, P0
cmovge P0, P3
cmovg P3, S0
cmp P1, S2
cmovg P2, P1
mov S1, P2
cmovg P1, S2
cmp S1, P0
cmovl S1, P0
mov S1, P3
cmovl P0, P2
cmp P1, P3
