# n=5 model=out iset=I1 prefix14_class=9655
mov S2, P1
cmp P0, P2
cmovge S0, P2
cmovl S0, P0
cmovl P0, P2
cmp S2, P3
cmovg P1, P3
cmovl S2, P3
cmp P0, S2
cmovge P2, P0
cmovge P0, S2
cmovge S2, P2
cmp S0, P1
cmovge P2, P1
