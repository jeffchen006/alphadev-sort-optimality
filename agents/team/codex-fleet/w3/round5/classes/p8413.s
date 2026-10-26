# n=5 model=out iset=I1 prefix14_class=8413
mov S2, P3
mov S1, P1
cmp S2, P2
cmovge S2, P2
cmovg P2, P3
cmp P0, S1
cmovg P1, P0
cmovl S1, P0
cmp P1, P2
cmovge P0, P2
cmovg P2, P1
cmovg P1, P0
mov S0, S2
cmp S1, S2
