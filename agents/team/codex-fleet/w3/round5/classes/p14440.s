# n=5 model=out iset=I1 prefix14_class=14440
mov S0, P0
cmp P0, P1
mov S1, P2
cmovl S0, P1
cmovge P0, P1
cmp P3, P2
cmovge P2, P3
mov P1, S0
cmovl S1, P3
cmp S1, P0
cmovge S2, S1
cmovge S1, P0
cmovge P0, S2
mov S1, P0
