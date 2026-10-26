# n=5 model=out iset=I1 prefix14_class=12081
mov S2, P2
cmp P2, P3
cmovg P2, P3
cmovl S2, P3
mov S1, P1
cmp P1, P0
cmovge S1, P0
mov S0, P2
cmovge P0, P1
cmp S1, S0
cmovg S0, S1
cmovl P2, S1
mov P2, S0
mov S1, S2
