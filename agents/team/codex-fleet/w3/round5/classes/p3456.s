# n=5 model=out iset=I1 prefix14_class=3456
mov S0, P2
cmp P1, P2
cmovg S0, P1
cmovge P1, P2
mov S1, P3
cmp S1, P0
cmovge P3, P0
cmovl S1, P0
cmp P1, P3
cmovge S2, P3
cmovge P3, P1
cmovge P1, S2
mov P0, S0
cmp S1, S0
