# n=5 model=out iset=I1 prefix14_class=554
cmp P1, P2
mov S1, P0
cmovg S0, P1
cmovge P1, P2
cmovg P2, S0
cmp S1, P3
cmovge S1, P3
cmovl P0, P3
mov S0, S1
mov S2, P2
cmp P1, S0
cmovg S0, P1
cmovl S1, P1
cmp P0, P2
