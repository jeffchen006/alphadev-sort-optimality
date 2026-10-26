# n=5 model=out iset=I1 prefix14_class=74
mov S0, P3
mov S2, P1
cmp P3, P0
cmovl S0, P0
cmovge P3, P0
cmp P2, P1
cmovge P1, P2
cmovl S2, P2
mov P2, S2
cmp S2, P3
cmovge P2, P3
cmovg P3, S2
mov S1, S0
cmp S1, P1
