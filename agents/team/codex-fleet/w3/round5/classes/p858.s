# n=5 model=out iset=I1 prefix14_class=858
mov S0, P1
cmp P3, P0
mov S1, P3
cmovl S1, P0
cmovge P3, P0
cmovg P0, S1
cmp S0, P2
cmovge S0, P2
cmovge P2, P1
cmp P2, S1
cmovge P0, P2
mov S2, P3
cmovl S1, P2
mov P0, S1
