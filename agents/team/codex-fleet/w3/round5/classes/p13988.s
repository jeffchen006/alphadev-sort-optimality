# n=5 model=out iset=I1 prefix14_class=13988
mov S2, P3
cmp P3, P0
cmovl S2, P0
cmovg P3, P0
cmp P2, P1
cmovge P0, P2
cmovg P2, P1
cmovg P1, P0
mov S1, P1
cmp S1, S2
cmovge S1, S2
cmovg S2, P1
mov S0, S1
mov P1, P3
