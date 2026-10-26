# n=5 model=out iset=I1 prefix14_class=9780
mov S2, P3
cmp P1, P3
cmovge S2, P1
mov S0, P2
cmovge P1, P3
cmp P0, S0
cmovge S0, P0
mov S1, S0
cmovge P0, P2
cmp S1, S2
cmovl S1, S2
cmovge S0, S2
cmp P0, P1
cmovge P3, P1
