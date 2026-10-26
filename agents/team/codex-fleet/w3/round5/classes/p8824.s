# n=5 model=out iset=I1 prefix14_class=8824
cmp P3, P1
mov S0, P0
cmovge S2, P1
cmovge P1, P3
cmovl S2, P3
cmp P2, P0
cmovg S0, P2
cmovl P0, P2
cmp P1, S0
cmovge P3, S0
cmovg S0, P1
mov S0, P0
cmovg P1, P3
cmp S2, S0
