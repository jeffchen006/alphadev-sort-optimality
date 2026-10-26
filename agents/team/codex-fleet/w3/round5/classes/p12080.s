# n=5 model=out iset=I1 prefix14_class=12080
mov S2, P2
cmp P2, P3
mov S1, P1
cmovl S2, P3
cmovg P2, P3
cmp S1, P0
cmovge S1, P0
mov S0, P2
cmovge P0, P1
cmp S1, P2
cmovg P2, S1
cmovl S0, S1
cmp S2, P0
cmovge P3, S2
