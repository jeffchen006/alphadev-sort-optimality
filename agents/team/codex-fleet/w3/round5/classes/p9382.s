# n=5 model=out iset=I1 prefix14_class=9382
cmp P2, P1
cmovg S2, P1
cmovg P1, P2
cmovg P2, S2
mov S1, P3
cmp S1, P0
cmovl S1, P0
cmovl P0, P3
cmp P0, P2
mov S2, P1
cmovge S0, P0
cmovge P0, P2
cmovg P2, S0
cmp P1, S1
