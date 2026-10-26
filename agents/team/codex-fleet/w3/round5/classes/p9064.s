# n=5 model=out iset=I1 prefix14_class=9064
cmp P2, P3
mov S1, P2
mov S2, P0
cmovge P2, P3
cmovge P3, S1
cmp P1, P0
cmovl S2, P1
mov S0, P3
cmovge P0, P1
cmp P0, S0
cmovge P3, P0
cmovl S0, P0
cmp S2, P2
cmovge P1, P2
