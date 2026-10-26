# n=5 model=out iset=I1 prefix14_class=8410
mov S2, P3
mov S1, P0
cmp S2, P1
cmovge S2, P1
cmovg P1, P3
cmp P2, S1
cmovg P0, P2
cmovl S1, P2
cmp P1, P0
cmovge P2, P0
cmovg P0, P1
cmovg P1, P2
mov S0, S1
cmp S2, S1
