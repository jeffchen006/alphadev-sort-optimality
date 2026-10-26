# n=5 model=out iset=I1 prefix14_class=2468
cmp P3, P2
cmovl S2, P3
cmovge S2, P2
cmovle P3, P2
cmp P0, P1
cmovg S0, P1
cmovge P1, P0
cmovg P0, S0
cmp P3, P1
cmovl P2, P1
cmovge P2, P3
cmovl P1, P3
cmp S2, P0
cmovg S0, S2
