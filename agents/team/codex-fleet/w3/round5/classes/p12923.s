# n=5 model=out iset=I1 prefix14_class=12923
mov S1, P3
cmp P0, P3
cmovl S1, P0
cmovge P3, P0
mov S0, P2
mov S2, S1
cmp P1, P2
cmovl P2, P1
cmovg S0, P1
cmp P2, S2
cmovge S2, P2
cmovge P2, S1
cmp S0, P3
cmovge S1, S0
