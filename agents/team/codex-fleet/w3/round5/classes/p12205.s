# n=5 model=out iset=I1 prefix14_class=12205
cmp P0, P2
mov S2, P2
cmovl P2, P0
cmovg S2, P0
cmp P1, P3
cmovl S1, P3
cmovl P3, P1
mov S0, P2
cmovl P1, S1
cmp S0, P3
cmovge S0, P3
cmovg P3, P2
cmp P1, S2
mov S0, S2
