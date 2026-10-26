# n=5 model=out iset=I1 prefix14_class=2593
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
cmovge P1, S0
mov S2, P0
cmp S2, P2
cmovg P0, P2
cmovl S2, P2
mov S1, S2
cmp S2, P3
cmovl S2, P3
cmovg S1, P3
cmp P1, P0
mov S2, P0
