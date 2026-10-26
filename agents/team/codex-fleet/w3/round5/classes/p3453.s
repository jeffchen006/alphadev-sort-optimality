# n=5 model=out iset=I1 prefix14_class=3453
mov S0, P2
cmp P0, S0
cmovge S0, P0
cmovge P0, P2
mov S1, P3
cmp S1, P1
cmovge P3, P1
cmovl S1, P1
cmp P3, P0
mov S2, S1
cmovge P1, P0
cmovge P0, P3
cmovge P3, P1
cmp S0, S1
