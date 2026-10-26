# n=5 model=out iset=I1 prefix14_class=1185
cmp P1, P0
cmovl S0, P1
cmovl P1, P0
cmovl P0, S0
mov S2, P3
cmp P3, P2
cmovl S2, P2
cmovg P3, P2
cmp S2, P1
cmovge S0, S2
cmovg S2, P1
cmovge P1, S0
mov P2, P0
cmp P2, P3
