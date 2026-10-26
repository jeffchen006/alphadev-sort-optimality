# n=5 model=out iset=I1 prefix14_class=8411
mov S2, P3
mov S1, P0
cmp S2, P2
cmovge S2, P2
cmovg P2, P3
cmp P1, S1
cmovg P0, P1
cmovl S1, P1
cmp P2, P0
cmovge P1, P0
cmovg P0, P2
cmovg P2, P1
mov S0, S1
cmp S2, S1
