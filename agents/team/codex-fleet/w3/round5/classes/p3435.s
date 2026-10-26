# n=5 model=out iset=I1 prefix14_class=3435
cmp P2, P1
mov S0, P0
cmovge S2, P1
cmovge P1, P2
cmovge P2, S2
cmp S0, P3
cmovl S0, P3
cmovg P0, P3
mov S1, P2
mov P3, P1
cmp P0, P2
cmovg S1, P0
cmovge P0, P2
cmp S0, P1
