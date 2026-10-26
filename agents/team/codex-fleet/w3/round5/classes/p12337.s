# n=5 model=out iset=I1 prefix14_class=12337
mov S0, P2
mov S1, P1
cmp S0, P3
cmovge S0, P3
cmovl P2, P3
cmp P0, P1
cmovg S1, P0
cmovg P0, P1
cmp P0, S0
cmovl P3, S0
cmovl S0, P0
cmovl P0, P3
cmp S1, P2
cmovge P3, S1
