# n=5 model=out iset=I1 prefix14_class=9224
cmp P0, P3
mov S2, P1
cmovg S1, P3
cmovge P3, P0
cmovg P0, S1
cmp S2, P2
cmovl S2, P2
cmovl P2, P1
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
cmovl S0, P0
mov P0, S2
cmp S2, P3
