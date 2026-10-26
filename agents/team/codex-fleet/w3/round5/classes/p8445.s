# n=5 model=out iset=I1 prefix14_class=8445
cmp P2, P1
cmovl S0, P1
mov S2, P3
cmovge S0, P2
cmovge P2, P1
cmp P0, S2
cmovg P3, P0
cmovg P0, S2
cmp S0, P3
mov P1, P2
cmovge S1, P3
cmovg P3, S0
cmovg S0, S1
cmp P2, P0
