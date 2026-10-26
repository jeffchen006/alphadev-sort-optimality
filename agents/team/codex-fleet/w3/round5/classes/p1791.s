# n=5 model=out iset=I1 prefix14_class=1791
cmp P3, P1
mov S2, P1
cmovge P1, P3
mov S1, P1
mov S0, P2
cmovg P3, S2
cmp P0, P2
cmovge S0, P0
cmovge P0, P2
cmp S1, S0
cmovg P1, S0
cmovl S1, S0
mov S1, P0
cmp P3, P0
