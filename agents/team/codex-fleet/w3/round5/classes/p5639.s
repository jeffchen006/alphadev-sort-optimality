# n=5 model=out iset=I1 prefix14_class=5639
cmp P1, P2
mov S1, P3
mov S2, P1
cmovg P1, P2
cmovl S2, P2
cmp P0, S1
cmovl S1, P0
cmovge P3, P0
cmp S1, P1
cmovge P2, P1
mov S0, S2
cmovge P1, S1
cmovge S1, P2
cmp S2, P3
