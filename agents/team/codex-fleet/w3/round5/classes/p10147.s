# n=5 model=out iset=I1 prefix14_class=10147
cmp P1, P3
cmovge S0, P3
mov S1, P0
cmovg P3, P1
mov S2, P3
cmovl S0, P1
cmp P2, P0
cmovge P0, P2
cmovl S1, P2
cmp P0, S2
cmovl P3, P0
cmovg S2, P0
cmp S0, S1
cmovg P0, S1
