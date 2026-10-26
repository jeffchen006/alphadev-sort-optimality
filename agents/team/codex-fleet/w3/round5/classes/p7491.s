# n=5 model=out iset=I1 prefix14_class=7491
mov S1, P2
cmp S1, P0
cmovl S1, P0
mov S0, P1
cmovg P2, P0
mov S2, P2
cmp S0, P3
cmovg S0, P3
cmovl P1, P3
cmp S0, P2
cmovl P2, S0
cmovg S2, S0
cmp S1, P1
cmovl P3, P1
