# n=5 model=out iset=I1 prefix14_class=1819
mov S0, P1
mov S2, P2
cmp P3, P1
cmovge P1, P3
cmovg P3, S0
cmp P0, P2
cmovge S2, P0
cmovg P0, P2
cmp S2, P1
mov P2, S2
cmovge P2, P1
cmovl S2, P1
mov S2, P0
cmp P3, S2
