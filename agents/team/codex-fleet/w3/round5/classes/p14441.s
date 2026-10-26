# n=5 model=out iset=I1 prefix14_class=14441
cmp P0, P1
mov S0, P0
cmovl S0, P1
mov S1, P2
cmovge P0, P1
cmp P3, P2
cmovge P2, P3
cmovl S1, P3
mov P3, S0
cmp S1, P0
cmovge P1, S1
cmovge S1, P0
cmovge P0, P1
mov S1, P0
