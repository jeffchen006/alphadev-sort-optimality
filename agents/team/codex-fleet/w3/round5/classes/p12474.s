# n=5 model=out iset=I1 prefix14_class=12474
cmp P2, P0
cmovl S1, P2
cmovge S1, P0
mov S0, P3
cmovl P2, P0
cmp S0, P1
cmovg S0, P1
cmovg P1, P3
cmp S0, S1
cmovge P0, S1
cmovg S1, S0
mov S2, P2
cmovge S0, P0
cmp P1, S2
