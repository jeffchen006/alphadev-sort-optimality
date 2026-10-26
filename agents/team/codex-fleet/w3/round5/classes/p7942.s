# n=5 model=out iset=I1 prefix14_class=7942
mov S2, P2
cmp P2, P0
cmovge P2, P0
cmovl S2, P0
mov P0, S2
mov S0, P3
cmp P3, P1
cmovg S0, P1
cmovg P1, P3
cmp S0, P2
cmovge P3, P2
cmovge P2, S0
cmovge S0, P3
cmp P0, P1
