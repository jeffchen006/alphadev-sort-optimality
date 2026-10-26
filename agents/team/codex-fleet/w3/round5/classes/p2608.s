# n=5 model=out iset=I1 prefix14_class=2608
cmp P3, P2
mov S0, P0
cmovg S1, P2
cmovg P2, P3
cmovg P3, S1
cmp P1, P0
cmovg S0, P1
cmovg P1, P0
cmp S0, P2
cmovge P0, P2
cmovl P0, S0
cmovl S0, P2
cmp P3, P1
cmovge S1, P1
