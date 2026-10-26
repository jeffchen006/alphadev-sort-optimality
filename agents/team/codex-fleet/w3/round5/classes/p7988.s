# n=5 model=out iset=I1 prefix14_class=7988
cmp P0, P1
cmovg S0, P1
cmovge P1, P0
cmovg P0, S0
mov S1, P3
cmp S1, P2
cmovge P3, P2
cmovg P2, S1
mov S2, P0
mov S1, P2
cmp S2, P3
cmovl S2, P3
cmovg P0, P3
cmp P1, S1
