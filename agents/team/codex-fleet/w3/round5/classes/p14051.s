# n=5 model=out iset=I1 prefix14_class=14051
mov S0, P1
cmp S0, P3
cmovge S0, P3
mov S1, P0
mov S2, S0
cmovge P3, P1
cmp S1, P2
cmovl S1, P2
cmovg P0, P2
cmp S1, P3
cmovge P2, S1
cmovge S1, P3
cmovg P3, P2
cmp P0, S0
