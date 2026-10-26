# n=5 model=out iset=I1 prefix14_class=3990
mov S1, P1
cmp S1, P2
cmovl S1, P2
cmovg P1, P2
mov S2, P0
cmp S2, P3
cmovge S2, P3
cmovge P3, P0
cmp P1, S2
cmovge P0, P1
cmovge P1, S2
mov S0, P3
cmovg S2, P0
cmp S1, P3
