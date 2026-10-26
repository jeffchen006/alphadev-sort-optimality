# n=5 model=out iset=I1 prefix14_class=1532
cmp P3, P1
cmovl S0, P3
cmovge S0, P1
cmovge P1, P3
cmp P0, P2
cmovl S1, P0
cmovge S1, P2
cmovg P2, P0
cmp S0, S1
cmovge P3, S0
cmovg S0, S1
cmovg S1, P3
cmp P2, P1
cmovl P0, P2
